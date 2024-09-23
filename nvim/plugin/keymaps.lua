if vim.g.plugin_keymaps then
  return
end
vim.g.plugin_keymaps = 1

local fn = vim.fn
local keymap = vim.keymap

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'Previous [b]uffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'Next [b]uffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'First [B]uffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'Last [B]uffer' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'Move down [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'Move up full-page and center' })
