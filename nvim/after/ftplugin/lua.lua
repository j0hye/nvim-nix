local lspconfig = require('lspconfig')

-- Lua
if vim.fn.executable('lua-language-server') then
    local server = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                codeLens = {
                    enable = true,
                },
                completion = {
                    callSnippet = 'Replace',
                },
                doc = {
                    privateName = { '^_' },
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = { disable = { 'missing-fields' } },
                hint = {
                    enable = true,
                    setType = false,
                    paramType = true,
                    paramName = 'Disable',
                    semicolon = 'Disable',
                    arrayIndex = 'Disable',
                },
                signatureHelp = {
                    enable = true,
                },
            },
        },
    }
    lspconfig.lua_ls.setup(server)
end
