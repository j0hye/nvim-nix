if vim.g.plugin_surround then
  return
end
vim.g.plugin_surround = 1

require('nvim-surround').setup {
  -- Surround binds
  -- https://github.com/ggandor/leap.nvim/discussions/59
  -- but with gs, gss, gSS
  keymaps = {
    insert = false,
    insert_line = false,
    normal = false, -- surround
    normal_cur = false, -- surround line
    normal_line = false, -- surround on new line
    normal_cur_line = false, -- surround line on new line
    visual = false, -- surround selected
    visual_line = false, -- surround selected on new line
    delete = false, -- delete nearest surround
    change = false, -- change nearest surround
    change_line = false, -- change nearest surround to surround on new line
  },
}
vim.keymap.set('n', 'gs', '<Plug>(nvim-surround-normal)', { desc = 'Surround' })
vim.keymap.set('n', 'gss', '<Plug>(nvim-surround-normal-cur)', { desc = 'Surround line' })
vim.keymap.set('n', 'gsc', '<Plug>(nvim-surround-change)', { desc = 'Change nearest surround' })
vim.keymap.set(
  'n',
  'gsC',
  '<Plug>(nvim-surround-change-line)',
  { desc = 'Change nearest surround to surround on new line' }
)
vim.keymap.set('n', 'gsd', '<Plug>(nvim-surround-delete)', { desc = 'Delete nearest surround' })
vim.keymap.set('n', 'gS', '<Plug>(nvim-surround-normal-line)', { desc = 'Surround on new line' })
vim.keymap.set('n', 'gSS', '<Plug>(nvim-surround-normal-cur-line)', { desc = 'Surround line on a new line' })

vim.keymap.set('x', 'gs', '<Plug>(nvim-surround-visual)', { desc = 'Surround selection' })
vim.keymap.set('x', 'gS', '<Plug>(nvim-surround-visual-line)', { desc = 'Surround selection on a new line' })

vim.keymap.set('i', '<C-g>s', '<Plug>(nvim-surround-insert)', { desc = 'Surround around cursor' })
vim.keymap.set('i', '<C-g>S', '<Plug>(nvim-surround-insert-line)', { desc = 'Surround around cursor on a new line' })
