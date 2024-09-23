if vim.g.plugin_plugins then
    return
end
vim.g.plugin_plugins = 1
-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs
require('ibl').setup()
require('dressing').setup()
require('lazydev').setup {}
