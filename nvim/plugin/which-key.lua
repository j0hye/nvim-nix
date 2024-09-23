if vim.g.plugin_whichkey then
  return
end
vim.g.plugin_whichkey = 1

require('which-key').setup {
  preset = 'modern',
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '', -- symbol prepended to a group
    ellipsis = '…',
    mappings = false,
  },
}

local wk = require('which-key')
wk.add {
  mode = { 'n', 'v' },
  { '<leader>c', group = '[C]ode' },

  { '<leader>g', group = '[G]it' },
  { '<leader>gd', group = '[D]iffview' },
  { '<leader>gh', group = '[H]unk' },
  { '<leader>ghb', group = '[B]uffer' },
  { '<leader>ght', group = '[T]oggle' },
  { '<leader>gn', group = '[N]eogit' },

  { '<leader>l', group = '[L]SP' },
  { '<leader>lt', group = '[T]reesitter' },

  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]elescope' },
  { '<leader>w', group = '[W]orkspace' },
}
