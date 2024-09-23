if vim.g.plugin_gitsigns then
  return
end
vim.g.plugin_gitsigns = 1

require('gitsigns').setup {
  current_line_blame = false,
  current_line_blame_opts = {
    ignore_whitespace = true,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then
        return ']g'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Next [g]it hunk' })

    map('n', '[g', function()
      if vim.wo.diff then
        return '[g'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Previous [g]it hunk' })

    -- Actions
    map({ 'n', 'v' }, '<leader>ghs', function()
      vim.cmd.Gitsigns('stage_hunk')
    end, { desc = '[S]tage hunk' })

    map({ 'n', 'v' }, '<leader>ghr', function()
      vim.cmd.Gitsigns('reset_hunk')
    end, { desc = '[R]eset hunk' })

    map('n', '<leader>ghbs', gs.stage_buffer, { desc = '[S]tage buffer' })
    map('n', '<leader>ghu', gs.undo_stage_hunk, { desc = '[U]ndo stage hunk' })
    map('n', '<leader>ghbr', gs.reset_buffer, { desc = '[R]eset buffer' })
    map('n', '<leader>ghp', gs.preview_hunk, { desc = '[P]review hunk' })

    map('n', '<leader>ghtf', function()
      gs.blame_line { full = true }
    end, { desc = 'Blame [f]ull' })

    map('n', '<leader>ghtl', gs.toggle_current_line_blame, { desc = 'Blame [l]ine' })
    map('n', '<leader>ghd', gs.diffthis, { desc = '[D]iff this' })

    map('n', '<leader>gh~', function()
      gs.diffthis('~')
    end, { desc = 'Diff this [~]' })

    map('n', '<leader>ghtd', gs.toggle_deleted, { desc = '[D]eleted' })
  end,
}
