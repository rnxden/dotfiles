--[[ Settings ]]

-- Keymaps
vim.g.mapleader = ' ' -- set global leader key
vim.g.maplocalleader = '\\' -- set buffer-local leader key
vim.opt.timeout = false -- remove timeout for keymaps

-- Recovery files
vim.opt.undofile = true -- save undo history
vim.opt.swapfile = true -- save unsaved file changes

-- Buffers
vim.opt.hidden = true -- keep buffers open in the background
vim.opt.autoread = true -- watch for external changes to files

-- Rendering
vim.opt.wrap = false -- disable line wrapping
vim.opt.lazyredraw = true -- disable screen redraws during macros
vim.opt.guicursor = 'a:block' -- always use block cursor
vim.opt.signcolumn = 'yes' -- always show sign column
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { -- configure whitespace characters
  trail = '·',
  tab = '» ',
}

-- Indentation
vim.opt.autoindent = true -- enable auto indent
vim.opt.smartindent = true -- enable smart indent
vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.tabstop = 2 -- make tabs 2 spaces wide
vim.opt.shiftwidth = 2 -- make indents 2 spaces wide

-- Splits
vim.opt.splitbelow = true -- open horizontal splits on the bottom
vim.opt.splitright = true -- open vertical splits on the right

-- Searching
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- don't ignore case when the search query has mixed casing
vim.opt.incsearch = true -- show search results incrementally
vim.opt.hlsearch = false -- don't highlight search results

vim.opt.matchpairs:append('<:>') -- match angle brackets

--[[ Keymaps ]]

-- Shortcut for exiting terminal mode
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>')

-- Shortcut for switching to previous buffer
vim.keymap.set('n', 'gb', '<C-^>')

-- Shortcut for copying to system register
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')

-- Shortcut for pasting from system register
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')

-- Shortcut for deleting without replacing register contents
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')
vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_D')

-- Center cursor when navigating
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')

-- Send j/k movements to jumplist when a count is used
vim.keymap.set('n', 'j', function()
  return (vim.v.count > 0 and ("m'" .. vim.v.count) or '') .. 'j'
end, { expr = true })

vim.keymap.set('n', 'k', function()
  return (vim.v.count > 0 and ("m'" .. vim.v.count) or '') .. 'k'
end, { expr = true })

--[[ Autocmds ]]

-- Enable relative line numbers only in normal mode
local number_toggle = vim.api.nvim_create_augroup('number_toggle', { clear = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  group = number_toggle,
  callback = function(args)
    if vim.bo[args.buf].buftype == '' then
      vim.opt.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = number_toggle,
  callback = function(args)
    if vim.bo[args.buf].buftype == '' then
      vim.opt.relativenumber = true
    end
  end,
})

--[[ Plugins ]]

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1.0.0') },

  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/vague-theme/vague.nvim' },
})

-- LSP
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('jsonls')
vim.lsp.enable('html')
vim.lsp.enable('cssls')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('pyright')
vim.lsp.enable('gopls')

require('lazydev').setup({})

-- Copilot
-- TODO: Copilot can be configured through an LSP server, switch to that?
require('copilot').setup({
  panel = {
    enabled = false,
  },

  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      -- <C-f> is the Neovim-recommended default, but is already used by blink.cmp
      accept = '<C-s>',
      accept_word = false,
      accept_line = false,
      next = '<C-g>',
      prev = false,
      dismiss = false,
    },
  },
})

-- Formatters
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },

    javascript = { 'biome' },
    typescript = { 'biome' },
    javascriptreact = { 'biome' },
    typescriptreact = { 'biome' },
    json = { 'biome' },
    html = { 'biome' },
    css = { 'biome' },

    python = { 'ruff_format', 'ruff_organize_imports' },

    go = { 'goimports' },
  },
})

vim.keymap.set('n', 'grf', function()
  require('conform').format({ async = true })
end)

-- Completion
require('blink.cmp').setup({
  completion = {
    menu = {
      scrolloff = 0, -- wtf why is this 2 by default
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
    },
  },

  keymap = {
    preset = 'none',

    ['<C-y>'] = { 'select_and_accept' },
    ['<C-e>'] = { 'cancel' },

    ['<C-n>'] = { 'show', 'select_next' },
    ['<C-p>'] = { 'show', 'select_prev' },

    ['<C-f>'] = { 'scroll_documentation_down' },
    ['<C-b>'] = { 'scroll_documentation_up' },

    ['<C-j>'] = { 'snippet_forward' },
    ['<C-k>'] = { 'snippet_backward' },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },

  cmdline = {
    enabled = true,
  },
})

-- TODO: Configure treesitter
-- NOTE: Neovim ships with lua/vim/vimdoc by default now, so maybe not needed? Check with other languages

-- Fuzzy finder
require('fzf-lua').setup({})

vim.keymap.set('n', '<leader>f', require('fzf-lua').files)
vim.keymap.set('n', '<leader>g', require('fzf-lua').live_grep)
vim.keymap.set('n', '<leader>h', require('fzf-lua').helptags)

-- Visuals
require('gitsigns').setup({})

-- Colorscheme
require('vague').setup({
  bold = true,
  italic = false,

  on_highlights = function(highlights)
    highlights.Normal.bg = 'none'
    highlights.SignColumn.bg = 'none'
    highlights.StatusLine.bg = 'none'
    highlights.StatusLineNC.bg = 'none'
  end,
})

vim.cmd('colorscheme vague')
