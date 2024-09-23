if vim.g.plugin_lspconfig then
    return
end
vim.g.plugin_lspconfig = 1

-- On attach keymap
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
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

-- Configure Neovim diagnostic messages
local function prefix_diagnostic(prefix, diagnostic)
    return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
    virtual_text = {
        prefix = '',
        format = function(diagnostic)
            local severity = diagnostic.severity
            if severity == vim.diagnostic.severity.ERROR then
                return prefix_diagnostic('󰅚', diagnostic)
            end
            if severity == vim.diagnostic.severity.WARN then
                return prefix_diagnostic('⚠', diagnostic)
            end
            if severity == vim.diagnostic.severity.INFO then
                return prefix_diagnostic('ⓘ', diagnostic)
            end
            if severity == vim.diagnostic.severity.HINT then
                return prefix_diagnostic('󰌶', diagnostic)
            end
            return prefix_diagnostic('■', diagnostic)
        end,
    },
    signs = {
        text = {
            -- Requires Nerd fonts
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '⚠',
            [vim.diagnostic.severity.INFO] = 'ⓘ',
            [vim.diagnostic.severity.HINT] = '󰌶',
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
}
require('lspconfig.ui.windows').default_options.border = 'rounded'

if vim.fn.executable('lua_ls') then
    local lspconfig = require('lspconfig')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local server = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = { disable = { 'missing-fields' } },
                hint = {
                    enable = true,
                },
                -- signatureHelp = {
                --     enable = false,
                -- },
            },
        },
    }
    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

    lspconfig['lua_ls'].setup(server)
    require('lazydev').setup {}

    -- LSP Signature setup
    local sig_opts = {
        bind = true,
        floating_window = true,
        handler_opts = { border = 'rounded' },
        hint_enable = false,
        hint_prefix = {
            above = '↙ ', -- when the hint is on the line above the current line
            current = '← ', -- when the hint is on the same line
            below = '↖ ', -- when the hint is on the line below the current line
        },
        wrap = false,
        hi_parameter = 'LspSignatureActiveParameter',
    }
    require('lsp_signature').setup(sig_opts)
end
