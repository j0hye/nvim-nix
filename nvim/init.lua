vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Colorscheme
require('gruvbox').setup {}
vim.cmd('colorscheme gruvbox')

-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- Disable showing the mode below the statusline
vim.opt.showmode = false

-- Set tabs to 2 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- Enable incremental searching
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Disable text wrap
vim.opt.wrap = false

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease updatetime to 200ms
vim.opt.updatetime = 50

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { 'menuone', 'noselect' }

-- Enable persistent undo history
vim.opt.undofile = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = 'yes'

-- Enable access to System Clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Set fold settings
-- These options were reccommended by nvim-ufo
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Place a column line
vim.opt.colorcolumn = '88'

-- Search down into subfolders
vim.opt.path = vim.o.path .. '**'

-- Lazy redraw off for noice
vim.opt.lazyredraw = false

-- Folds fill chars
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Look for .editorconfig
vim.g.editorconfig = true

-- Native plugins
vim.cmd.filetype('plugin', 'indent', 'on')
vim.cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
