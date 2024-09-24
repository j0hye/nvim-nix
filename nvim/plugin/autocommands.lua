if vim.g.plugin_autocommands then
    return
end
vim.g.plugin_autocommands = 1

local api = vim.api

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Toggle diagnostics. We keep track of the toggling state.
local show_diagnostics = true
local function toggle_diagnostics()
    show_diagnostics = not show_diagnostics
    vim.diagnostic.enable(show_diagnostics)

    if show_diagnostics then
        vim.notify('Diagnostics activated.')
    else
        vim.notify('Diagnostics hidden.')
    end
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

        vim.keymap.set('n', 'gl', function()
            return vim.diagnostic.open_float(nil, { focus = false, border = 'rounded' })
        end, { desc = 'Show diagnostics' })
        vim.keymap.set('n', '<leader>ld', toggle_diagnostics, { desc = 'Toggle [d]iagnostics' })

        if client.server_capabilities.completionProvider then
            -- Enable completion triggered by <c-x><c-o>.
            vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        end

        if client.server_capabilities.definitionProvider then
            vim.bo[event.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', buffer = event.buf })
        end

        if client.server_capabilities.declarationProvider then
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', buffer = event.buf })
        end

        if client.server_capabilities.documentRangeFormattingProvider then
            vim.keymap.set('v', '<leader>lf', function()
                vim.lsp.buf.range_formatting { async = true }
            end, { desc = 'Range [f]ormat', buffer = event.buf })
        end

        if client.server_capabilities.signatureHelpProvider then
            vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature', buffer = event.buf })
        end

        if client.server_capabilities.implementationProvider then
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation', buffer = event.buf })
        end

        vim.keymap.set('n', '<leader>d', function()
            local _, winid = vim.diagnostic.open_float(nil, { scope = 'line' })
            if not winid then
                vim.notify('No diagnostic found', vim.log.levels.INFO)
                return
            end
            vim.api.nvim_win_set_config(winid or 0, { focusable = true })
        end, { noremap = true, silent = true, desc = 'Show line [d]iagnostics' })

        -- #TODO byt till telescope
        if client.server_capabilities.workspaceSymbolProvider then
            vim.keymap.set(
                'n',
                '<leader>lw',
                vim.lsp.buf.workspace_symbol,
                { desc = 'List [w]orkspace symbols', buffer = event.buf }
            )
        end
        -- #TODO: Code action, Codelens, format, workspace/doc symbols, toggle inlay hints
        --- goto references, rename

        -- Codelens refresh
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
            api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = augroup('cursor-hl'),
                callback = vim.lsp.buf.document_highlight,
            })

            api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = augroup('cursor-hl'),
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
