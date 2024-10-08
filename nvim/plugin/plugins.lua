if vim.g.plugin_plugins then
    return
end
vim.g.plugin_plugins = 1
-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs
require('lazydev').setup {}
require('ibl').setup {
    indent = {
        char = '┊',
    },
}
require('dressing').setup {}
require('todo-comments').setup {}
require('guess-indent').setup {}
require('nvim-autopairs').setup {}
-- require('tabout').setup {}
