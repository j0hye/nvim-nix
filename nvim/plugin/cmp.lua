require('blink.cmp').setup {
    -- for keymap, all values may be string | string[]
    -- use an empty table to disable a keymap
    keymap = {
        show = '<C-space>',
        hide = '<C-e>',
        accept = '<C-y>',
        select_prev = { '<Up>', '<C-p>' },
        select_next = { '<Down>', '<C-n>' },

        show_documentation = {},
        hide_documentation = {},
        scroll_documentation_up = '<C-b>',
        scroll_documentation_down = '<C-f>',
        snippet_forward = '<C-l>',
        snippet_backward = '<C-h>',
    },
    windows = {
        autocomplete = {
            border = 'rounded',
        },
        documentation = {
            border = 'rounded',
        },
        signature_help = {
            border = 'rounded',
        },
    },
    highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
    },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'normal',
}

-- -- See `:help cmp`
-- local lspconfig = require('lspconfig')
-- local lspdefaults = lspconfig.util.default_config
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
-- -- Add completion capabilites to LSP
-- lspdefaults.capabilities = vim.tbl_deep_extend('force', lspdefaults.capabilities, capabilities)
--
-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
--
-- local kind_icons = {
--     Class = '󰠱 ',
--     Color = '󰏘 ',
--     Constant = '󰏿 ',
--     Constructor = ' ',
--     Enum = ' ',
--     EnumMember = ' ',
--     Event = ' ',
--     Field = '󰇽 ',
--     File = '󰈙 ',
--     Folder = '󰉋 ',
--     Function = '󰊕 ',
--     Interface = ' ',
--     Keyword = '󰌋 ',
--     Method = '󰆧 ',
--     Module = ' ',
--     Operator = '󰆕 ',
--     Property = '󰜢 ',
--     Reference = ' ',
--     Snippet = ' ',
--     Struct = ' ',
--     Text = ' ',
--     TypeParameter = '󰅲 ',
--     Unit = ' ',
--     Value = '󰎠 ',
--     Variable = '󰂡 ',
-- }
--
-- local menu_icons = {
--     calc = ' ',
--     gitmoji = ' ',
--     luasnip = ' ',
--     neorg = ' ',
--     nvim_lsp = 'λ ',
--     path = ' ',
--     rg = ' ',
--     treesitter = ' ',
--     vimtex = ' ',
-- }
--
-- local cmp = require('cmp')
-- local types = require('cmp.types')
-- local compare = require('cmp.config.compare')
-- local luasnip = require('luasnip')
--
-- ---@type table<integer, integer>
-- local modified_priority = {
--     [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
--     [types.lsp.CompletionItemKind.Snippet] = 0, -- top
--     [types.lsp.CompletionItemKind.Keyword] = 0, -- top
--     [types.lsp.CompletionItemKind.Text] = 100, -- bottom
-- }
-- ---@param kind integer: kind of completion entry
-- local function modified_kind(kind)
--     return modified_priority[kind] or kind
-- end
--
-- -- local buffers = {
-- --     name = 'buffer',
-- --     option = {
-- --         keyword_length = 3,
-- --         get_bufnrs = function() -- from all buffers (less than 1MB)
-- --             local bufs = {}
-- --             for _, bufn in ipairs(vim.api.nvim_list_bufs()) do
-- --                 local buf_size = vim.api.nvim_buf_get_offset(bufn, vim.api.nvim_buf_line_count(bufn))
-- --                 if buf_size < 1024 * 1024 then
-- --                     table.insert(bufs, bufn)
-- --                 end
-- --             end
-- --             return bufs
-- --         end,
-- --     },
-- -- }
--
-- cmp.setup {
--     snippet = {
--         expand = function(args)
--             luasnip.lsp_expand(args.body)
--         end,
--     },
--     mapping = cmp.mapping.preset.insert {
--         ['<C-n>'] = cmp.mapping.select_next_item(),
--         ['<C-p>'] = cmp.mapping.select_prev_item(),
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-y>'] = cmp.mapping.confirm { select = true },
--         ['<C-Space>'] = cmp.mapping.complete {},
--         ['<C-l>'] = cmp.mapping(function()
--             if luasnip.expand_or_locally_jumpable() then
--                 luasnip.expand_or_jump()
--             end
--         end, { 'i', 's' }),
--         ['<C-h>'] = cmp.mapping(function()
--             if luasnip.locally_jumpable(-1) then
--                 luasnip.jump(-1)
--             end
--         end, { 'i', 's' }),
--     },
--     sources = cmp.config.sources {
--         {
--             name = 'lazydev',
--             -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
--             group_index = 0,
--         },
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'path' },
--     },
--     formatting = {
--         fields = { 'menu', 'abbr', 'kind' },
--         expandable_indicator = true,
--         format = function(entry, item)
--             item.menu = menu_icons[entry.source.name]
--             item.kind = string.format('%s %s', kind_icons[item.kind] or '󰠱 ', item.kind)
--
--             return item
--         end,
--     },
--     sorting = {
--         -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
--         comparators = {
--             compare.offset,
--             compare.exact,
--             function(entry1, entry2) -- sort by length ignoring "=~"
--                 local len1 = string.len(string.gsub(entry1.completion_item.label, '[=~()_]', ''))
--                 local len2 = string.len(string.gsub(entry2.completion_item.label, '[=~()_]', ''))
--                 if len1 ~= len2 then
--                     return len1 - len2 < 0
--                 end
--             end,
--             compare.recently_used,
--             function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
--                 local kind1 = modified_kind(entry1:get_kind())
--                 local kind2 = modified_kind(entry2:get_kind())
--                 if kind1 ~= kind2 then
--                     return kind1 - kind2 < 0
--                 end
--             end,
--             function(entry1, entry2) -- score by lsp, if available
--                 local t1 = entry1.completion_item.sortText
--                 local t2 = entry2.completion_item.sortText
--                 if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
--                     return t1 < t2
--                 end
--             end,
--             compare.score,
--             compare.order,
--         },
--     },
--     confirm_opts = {
--         behavior = cmp.ConfirmBehavior.Replace,
--         select = false,
--     },
--     experimental = {
--         ghost_text = false,
--     },
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
-- }
--
-- -- from nvim-autopairs
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })
--
-- -- from cmdline
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' },
--     }, {
--         { name = 'cmdline' },
--     }),
-- })
