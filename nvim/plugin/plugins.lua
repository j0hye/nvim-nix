if vim.g.plugin_plugins then
    return
end
vim.g.plugin_plugins = 1
-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs
require('ibl').setup {
    indent = {
        char = '┊',
    },
}
require('dressing').setup {}
require('lazydev').setup {}
require('todo-comments').setup {}
require('guess-indent').setup {}
require('outline').setup {}
vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle [o]utline' })
