require('trouble').setup {
    keys = {
        {
            '<leader>qd',
            '<cmd>Trouble diagnostics toggle<cr>',
            desc = '[D]iagnostics',
        },
        {
            '<leader>qb',
            '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
            desc = '[B]uffer diagnostics',
        },
        {
            '<leader>qs',
            '<cmd>Trouble symbols toggle focus=false<cr>',
            desc = '[S]ymbols',
        },
        {
            '<leader>qr',
            '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
            desc = 'LSP Definitions / [r]eferences / ...',
        },
        {
            '<leader>qt',
            '<cmd>Trouble telescope toggle<cr>',
            desc = '[T]rouble telescope',
        },
        {
            '<leader>ql',
            '<cmd>Trouble loclist toggle<cr>',
            desc = '[L]ocation list',
        },
        {
            '<leader>qq',
            '<cmd>Trouble qflist toggle<cr>',
            desc = '[Q]uickfix list',
        },
    },
}
