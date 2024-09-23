if vim.g.plugin_autocommands then
    return
end
vim.g.plugin_autocommands = 1

local api = vim.api

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- On attach keymap
api.nvim_create_autocmd('LspAttach', {
    group = augroup('lsp-attach'),
    callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, 'Goto definition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, 'Goto references')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto implementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>d', require('telescope.builtin').lsp_type_definitions, 'Type [d]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Document [s]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace symbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>r', vim.lsp.buf.rename, '[R]ename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>a', vim.lsp.buf.code_action, 'Code [a]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, 'Goto declaration')

        -- Conform format with LSP fallback
        map('<leader>f', function()
            require('conform').format()
        end, '[F]ormat')
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>h', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay [h]ints')
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
