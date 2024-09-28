local M = {}

M.setup = function()
    require('lspconfig').lua_ls.setup {
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
end
return M
