if vim.g.plugin_lspconfig then
    return
end
vim.g.plugin_lspconfig = 1

local lspconfig = require('lspconfig')

-- Languages
require('plugins.lang.lua').setup()
-- require('plugins.lang.nix')
-- require('plugins.lang.c')
--
-- C
if vim.fn.executable('clangd') then
    lspconfig.clangd.setup {}
end

-- -- Lua
-- if vim.fn.executable('lua-language-server') then
--     local server = {
--         settings = {
--             Lua = {
--                 workspace = {
--                     checkThirdParty = false,
--                 },
--                 codeLens = {
--                     enable = true,
--                 },
--                 completion = {
--                     callSnippet = 'Replace',
--                 },
--                 doc = {
--                     privateName = { '^_' },
--                 },
--                 -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--                 diagnostics = { disable = { 'missing-fields' } },
--                 hint = {
--                     enable = true,
--                     setType = false,
--                     paramType = true,
--                     paramName = 'Disable',
--                     semicolon = 'Disable',
--                     arrayIndex = 'Disable',
--                 },
--                 signatureHelp = {
--                     enable = true,
--                 },
--             },
--         },
--     }
--     lspconfig.lua_ls.setup(server)
-- end

-- Nix
if vim.fn.executable('nil') then
    lspconfig.nil_ls.setup {}
end
-- if vim.fn.executable('nixd') then
--     lspconfig.nixd.setup {}
-- end

-- LSP Signature setup
local sig_opts = {
    bind = true,
    floating_window = false,
    handler_opts = { border = 'rounded' },
    hint_enable = true,
    hint_prefix = {
        above = '↙ ', -- when the hint is on the line above the current line
        current = '← ', -- when the hint is on the same line
        below = '↖ ', -- when the hint is on the line below the current line
    },
    wrap = false,
    hi_parameter = 'LspSignatureActiveParameter',
}
require('lsp_signature').setup(sig_opts)

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
