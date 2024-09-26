if vim.g.plugin_telescope then
    return
end
vim.g.plugin_telescope = 1

local open_with_trouble = require('trouble.sources.telescope').open
local add_to_trouble = require('trouble.sources.telescope').add

require('telescope').setup {
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    defaults = {
        mappings = {
            i = {
                ['<c-t>'] = open_with_trouble,
                ['<c-a>'] = add_to_trouble,
            },
            n = {
                ['<c-t>'] = open_with_trouble,
                ['<c-a>'] = add_to_trouble,
            },
        },
    },
    -- pickers = {}
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'noice')

-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [h]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search [k]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search [f]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Search [s]elect telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current [w]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by [g]rep' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search [r]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent files [.]' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzy search current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end, { desc = 'Search [/] in open files' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = '~/.config/nvim-nix' }
end, { desc = 'Search [n]eovim files' })

-- Extra pickers
vim.keymap.set('n', '<leader>tc', '<cmd>Telescope colorscheme<CR>', { desc = '[C]olorschemes' })
vim.keymap.set('n', '<leader>tn', '<cmd>Telescope noice<CR>', { desc = '[N]oice' })
vim.keymap.set('n', '<leader>td', '<cmd>Telescope diagnostics<CR>', { desc = '[D]iagnostics' })
vim.keymap.set('n', '<leader>tm', '<cmd>Telescope marks<CR>', { desc = '[M]arks' })
vim.keymap.set('n', '<leader>tr', '<cmd>Telescope marks<CR>', { desc = '[R]egisters' })
