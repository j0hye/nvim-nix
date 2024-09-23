vim.cmd('colorscheme gruvbox')

local hl = vim.api.nvim_set_hl

hl(0, 'SignColumn', { link = 'Normal' })

hl(0, 'NoiceCmdlinePopupBorder', { link = 'NoiceCmdlinePopup' })
hl(0, 'NoiceCmdlineIcon', { link = 'NoiceCmdlinePopup' })

hl(0, 'NoiceCmdlinePopupBorderSearch', { link = 'NoiceCmdlinePopupBorder' })
hl(0, 'NoiceCmdlineIconSearch', { link = 'NoiceCmdlineIcon' })

hl(0, 'WhichKeyNormal', { link = 'Normal' })
hl(0, 'WhichKeyBorder', { link = 'WhichKeyNormal' })

hl(0, 'NormalFloat', { link = 'Normal' })

hl(0, 'DiagnosticSignWarn', { bg = 'None', fg = '#FABD2F' })
hl(0, 'DiagnosticSignError', { bg = 'None', fg = '#FB4934' })
hl(0, 'DiagnosticSignInfo', { bg = 'None', fg = '#83A598' })
hl(0, 'DiagnosticSignHint', { bg = 'None', fg = '#8EC07C' })
hl(0, 'DiagnosticSignOk', { bg = 'None', fg = '#B8BB26' })
