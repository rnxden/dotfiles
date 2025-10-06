local opt = vim.opt

-- Keymaps
vim.g.mapleader = ' ' -- space as leader key
vim.g.maplocalleader = '\\' -- backslash as buffer-local leader key
opt.timeout = false -- remove timeout for keymaps

-- Recovery files
opt.writebackup = true -- save backup before writing to files
opt.backup = false -- delete backup after writing to files
opt.undofile = true -- save undo history
opt.swapfile = true -- save changes made to files

-- Buffers
opt.hidden = true -- keep buffers open in the background
opt.autoread = true -- watch for external changes to files

-- Rendering
opt.wrap = false -- don't wrap words that don't fit onscreen
opt.lazyredraw = true -- reduce unnecessary screen redraws
opt.guicursor = 'a:block' -- use block cursor for all modes
opt.signcolumn = 'yes' -- always show sign column

-- Indentation
opt.autoindent = true -- enable auto indent
opt.smartindent = true -- enable smart indent
opt.expandtab = true -- expand tabs into spaces
opt.tabstop = 2 -- make tabs 2 spaces wide
opt.softtabstop = 2 -- make tabs insert 2 spaces
opt.shiftwidth = 2 -- make indents 2 spaces wide

-- Folds
opt.foldmethod = 'indent' -- fold based on indents
opt.foldlevelstart = 99 -- open all folds by default

-- Splits
opt.splitbelow = true -- open horizontal splits on the bottom
opt.splitright = true -- open vertical splits on the right

-- Searching
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- don't ignore case when the search query has mixed casing
opt.incsearch = true -- show search results incrementally
opt.hlsearch = false -- don't highlight search results

opt.matchpairs:append('<:>') -- pair up angled brackets
