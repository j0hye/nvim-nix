require('bufferline').setup {
    options = {
        close_command = function(n)
            require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = function(n)
            require('mini.bufremove').delete(n, false)
        end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
    },
}
-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd('BufAdd', {
    callback = function()
        vim.schedule(function()
            pcall(nvim_bufferline)
        end)
    end,
})
