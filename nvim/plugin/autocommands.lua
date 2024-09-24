if vim.g.plugin_autocommands then
    return
end
vim.g.plugin_autocommands = 1

local api = vim.api

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- LSP Attach
api.nvim_create_autocmd('LspAttach', {
    group = augroup('lsp-attach'),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- LSP Keymaps
        if client == nil then
            vim.notify('No client attached to buffer ' .. event.buf, vim.log.levels.ERROR)
            return
        end

        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, 'Goto definition')
        map('gD', vim.lsp.buf.declaration, 'Goto declaration')
        map('gr', require('telescope.builtin').lsp_references, 'Goto references')
        map('gi', require('telescope.builtin').lsp_implementations, 'Goto implementation')
        map('<leader>d', require('telescope.builtin').lsp_type_definitions, 'Type [d]efinition')
        map('<leader>ld', require('telescope.builtin').lsp_document_symbols, '[D]ocument symbols')
        map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace symbols')
        map('<leader>cr', vim.lsp.buf.rename, '[R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ction', { 'n', 'x' })
        map('<leader>cl', vim.lsp.codelens.run, 'Run Code[l]ens')
        map('<C-k>', vim.lsp.buf.signature_help, 'Show signature help', 'i')

        -- Format with Conform and LSP fallback
        map('<leader>f', function()
            require('conform').format()
        end, '[F]ormat buffer')

        -- LSP Range format
        map('<leader>f', function()
            vim.lsp.buf.range_formatting { async = true }
        end, '[F]ormat range', 'v')

        -- Show line diagnostics
        map('<leader>cd', function()
            local _, winid = vim.diagnostic.open_float(nil, { scope = 'line' })
            if not winid then
                vim.notify('No diagnostic found', vim.log.levels.INFO)
                return
            end
            vim.api.nvim_win_set_config(winid or 0, { focusable = true })
        end, 'Show line [d]iagnostics')

        -- Toggle inlay hints
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay [h]ints')
        end

        -- Codelens auto refresh
        if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
                group = augroup('cl-refresh'),
                callback = function()
                    vim.lsp.codelens.refresh { bufnr = event.buf }
                end,
                buffer = event.buf,
            })
            vim.lsp.codelens.refresh { bufnr = event.buf }
        end

        -- Cursor word highlight
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local cursorword_hl = augroup('cursor-hl')
            api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = cursorword_hl,
                callback = vim.lsp.buf.document_highlight,
            })

            api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = cursorword_hl,
                callback = vim.lsp.buf.clear_references,
            })

            api.nvim_create_autocmd('LspDetach', {
                group = augroup('cursor-hl-detach'),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'cursor-hl', buffer = event2.buf }
                end,
            })
        end
    end,
})

-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
    pattern = '/tmp/*',
    group = augroup('tmpdir'),
    callback = function()
        vim.cmd.setlocal('noundofile')
    end,
})

-- Disable spell checking in terminal buffers
api.nvim_create_autocmd('TermOpen', {
    group = augroup('nospell'),
    callback = function()
        vim.wo[0].spell = false
    end,
})

--- Don't create a comment string when hitting <Enter> on a comment line
api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
    end,
})

-- Highlight on yank
api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight_yank'),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Close some filetypes with <q>
api.nvim_create_autocmd('FileType', {
    group = augroup('close_with_q'),
    pattern = {
        'PlenaryTestPopup',
        'help',
        'lspinfo',
        'notify',
        'qf',
        'query',
        'spectre_panel',
        'startuptime',
        'tsplayground',
        'neotest-output',
        'checkhealth',
        'neotest-summary',
        'neotest-output-panel',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

-- Resize splits if window got resized
api.nvim_create_autocmd({ 'VimResized' }, {
    group = augroup('resize_splits'),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

-- Make it easier to close man-files when opened inline
api.nvim_create_autocmd('FileType', {
    group = augroup('man_unlisted'),
    pattern = { 'man' },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
    end,
})

-- Wrap and check for spell in text filetypes
api.nvim_create_autocmd('FileType', {
    group = augroup('wrap_spell'),
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup('json_conceal'),
    pattern = { 'json', 'jsonc', 'json5' },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})
