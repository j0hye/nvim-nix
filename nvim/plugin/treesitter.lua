if vim.g.plugin_treesitter then
    return
end
vim.g.plugin_treesitter = 1

require('nvim-treesitter.configs').setup {
    modules = {},

    -- All parsers are installed with nix.
    ensure_installed = {},
    sync_install = false,
    auto_install = false,
    ignore_install = {},

    -- Highlight based on treesitter.
    highlight = {
        enable = true,
    },

    -- Indentation based on treesitter (use `=` operator).
    indent = { enable = true },

    -- Incremental selection in the parsed tree.
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },

    -- Manipulate text-objects.
    textobjects = {
        -- Adding text-objects to select operators.
        select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
                ['af'] = { query = '@function.outer', desc = 'Select function outer' },
                ['if'] = { query = '@function.inner', desc = 'Select function inner' },
                ['ac'] = { query = '@comment.outer', desc = 'Select comment outer' },
                ['ic'] = { query = '@comment.inner', desc = 'Select comment inner' },
                ['al'] = { query = '@loop.outer', desc = 'Select loop outer' },
                ['il'] = { query = '@loop.inner', desc = 'Select loop innter' },
                ['ai'] = { query = '@conditional.outer', desc = 'Select conditional outer' },
                ['ii'] = { query = '@conditional.inner', desc = 'Select conditional inner' },
                ['aa'] = { query = '@parameter.outer', desc = 'Select argument outer' },
                ['ia'] = { query = '@parameter.inner', desc = 'Select argument inner' },
            },
        },
    },
}
require('treesitter-context').setup {
    enable = true,
    max_lines = 3,
}
-- Use treesitter expressions for folds.
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
