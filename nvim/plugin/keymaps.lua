if vim.g.plugin_keymaps then
    return
end
vim.g.plugin_keymaps = 1

local fn = vim.fn
local keymap = vim.keymap

-- : to ö
keymap.set({ 'n', 'v' }, 'ö', ':', { desc = 'which_key_ignore' })

-- Shift-h/l start/end of line
keymap.set({ 'n', 'x', 'o' }, 'H', '^', { desc = 'First char of line' })
keymap.set({ 'n', 'x', 'o' }, 'L', '$', { desc = 'Last char of line' })

-- :noh to esc
keymap.set({ 'n', 'x', 'i' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'which_key_ignore' })

-- Move lines with alt+jk
keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'which_key_ignore' })
keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'which_key_ignore' })

keymap.set('x', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'which_key_ignore' })
keymap.set('x', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'which_key_ignore' })

keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'which_key_ignore' })
keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'which_key_ignore' })

-- Toggle autopairs
keymap.set('n', '<leader>ua', function()
    require('nvim-autopairs').toggle()
    if require('nvim-autopairs').state.disabled then
        vim.notify('Autopairs off', vim.log.levels.INFO)
    else
        vim.notify('Autopairs on', vim.log.levels.INFO)
    end
end, { desc = 'Toggle [a]utopairs' })

-- Window movement
keymap.set({ 'n', 'x' }, '<C-h>', '<C-w>h', { desc = 'which_key_ignore' })
keymap.set({ 'n', 'x' }, '<C-j>', '<C-w>j', { desc = 'which_key_ignore' })
keymap.set({ 'n', 'x' }, '<C-k>', '<C-w>k', { desc = 'which_key_ignore' })
keymap.set({ 'n', 'x' }, '<C-l>', '<C-w>l', { desc = 'which_key_ignore' })

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- Move and center
keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'Move down [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'Move up full-page and center' })

-- UI
keymap.set('n', '<leader>ui', '<cmd>LspInfo<CR>', { desc = 'Show LSP [i]nfo' })
keymap.set('n', '<leader>un', '<cmd>Telescope notify<CR>', { desc = 'Show [n]otifications' })
keymap.set('n', '<leader>uc', '<cmd>NoiceDismiss<CR>', { desc = '[C]lear notifications' })
keymap.set('n', '<leader>ul', function()
    if vim.wo.relativenumber then
        vim.wo.relativenumber = false
        vim.notify('Relative line numbers off', vim.log.levels.INFO)
    else
        vim.wo.relativenumber = true
        vim.notify('Relative line numbers on', vim.log.levels.INFO)
    end
end, { desc = 'Toggle relative [l]ine numbers' })
vim.keymap.set('n', '<leader>un', '<cmd>Telescope notify<CR>', { desc = 'Show [n]otifications' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
    if fn.getcmdtype() == ':' then
        return fn.expand('%:h') .. '/'
    else
        return '%%'
    end
end, { expr = true, desc = "expand to current buffer's directory" })
