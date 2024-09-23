local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '

opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
    opt.termguicolors = true
end

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = false
opt.showmatch = true -- Highlight matching parentheses, etc
opt.matchtime = 0
opt.incsearch = true
opt.hlsearch = true
opt.wrap = false

opt.spell = false
opt.spelllang = 'en'

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.mouse = 'a'

opt.ignorecase = true
opt.smartcase = true

opt.updatetime = 50

opt.clipboard = 'unnamed,unnamedplus'

opt.scrolloff = 8

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.wo.signcolumn = 'yes' -- Always shows the sign column (where we put gitsigns and warnings).

g.editorconfig = true

vim.opt.colorcolumn = '100'

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
