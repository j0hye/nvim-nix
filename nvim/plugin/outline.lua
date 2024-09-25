require('outline').setup {
    outline_window = {
        width = 35,
    },
}
vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle [o]utline' })
