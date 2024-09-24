if vim.g.plugin_flash then
    return
end
vim.g.plugin_flash = 1

require('flash').setup {
    modes = {
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
            enabled = true,
            -- hide after jump when not using jump labels
            autohide = false,
            -- show jump labels
            jump_labels = false,
            -- set to `false` to use the current line only
            multi_line = false,
            -- backdrop
            highlight = { backdrop = false },
        },
    },
}
vim.keymap.set({ 'n', 'x', 'o' }, 's', "<cmd>lua require('flash').jump()<cr>", { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', "<cmd>lua require('flash').treesitter()<cr>", { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', "<cmd>lua require('flash').remote()<cr>", { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', "<cmd>lua require('flash').treesitter_search()<cr>", { desc = 'Treesitter Search' })
vim.keymap.set('c', '<C-s>', "<cmd>lua require('flash').toggle()<cr>", { desc = 'Toggle Flash Search' })
