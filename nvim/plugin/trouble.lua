require('trouble').setup {}

vim.keymap.set('n', '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', { desc = '[D]iagnostics' })
vim.keymap.set('n', '<leader>db', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = '[B]uffer diagnostics' })
vim.keymap.set('n', '<leader>ds', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = '[S]ymbols' })
vim.keymap.set(
    'n',
    '<leader>dr',
    '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
    { desc = 'LSP Definitions / [r]eferences / ...' }
)
vim.keymap.set('n', '<leader>dt', '<cmd>Trouble telescope toggle<cr>', { desc = '[T]rouble telescope' })
vim.keymap.set('n', '<leader>dl', '<cmd>Trouble loclist toggle<cr>', { desc = '[L]ocation list' })
vim.keymap.set('n', '<leader>dq', '<cmd>Trouble qflist toggle<cr>', { desc = '[Q]uickfix list' })
