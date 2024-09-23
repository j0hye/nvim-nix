if vim.g.plugin_flash then
  return
end
vim.g.plugin_flash = 1

require('flash').setup {
  opts = {
    modes = {
      char = {
        multiline = false,
      },
    },
  },
}
vim.keymap.set({ 'n', 'x', 'o' }, 's', "<cmd>lua require('flash').jump()<cr>", { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', "<cmd>lua require('flash').treesitter()<cr>", { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', "<cmd>lua require('flash').remote()<cr>", { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', "<cmd>lua require('flash').treesitter_search()<cr>", { desc = 'Treesitter Search' })
vim.keymap.set('c', '<C-s>', "<cmd>lua require('flash').toggle()<cr>", { desc = 'Toggle Flash Search' })
