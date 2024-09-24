if vim.g.plugin_toggleterm then
    return
end
vim.g.plugin_toggleterm = 1

require('toggleterm').setup {
    direction = 'vertical',
    autochdir = true,
    size = 45,
    start_in_insert = true,
}
-- Easier escape from terminal buffers
vim.keymap.set({ 'n', 'i', 't' }, '<C-t>', '<Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
