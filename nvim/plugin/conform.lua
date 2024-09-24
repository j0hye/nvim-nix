if vim.g.plugin_conform then
    return
end
vim.g.plugin_conform = 1

require('conform').setup {
    formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
}
