if vim.g.plugin_oil then
  return
end
vim.g.plugin_oil = 1

require('oil').setup {
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
  },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 0,
  },
  win_options = {
    wrap = true,
    winblend = 0,
  },
  keymaps = {
    ['<C-c>'] = false,
    ['q'] = 'actions.close',
  },
}
vim.keymap.set('n', '<leader>e', function()
  require('oil').toggle_float()
end, { desc = 'Toggle [e]xplorer' })
