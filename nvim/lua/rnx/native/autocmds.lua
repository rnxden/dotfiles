local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local augroup_opts = { clear = true }

-- Enable relative line numbers only when in normal mode
local number_toggle = augroup('number_toggle', augroup_opts)

vim.opt.number = true
vim.opt.relativenumber = true

autocmd('InsertEnter', {
  group = number_toggle,
  callback = function(args)
    if vim.bo[args.buf].buftype == '' then
      vim.opt.relativenumber = false
    end
  end,
})

autocmd('InsertLeave', {
  group = number_toggle,
  callback = function(args)
    if vim.bo[args.buf].buftype == '' then
      vim.opt.relativenumber = true
    end
  end,
})

-- Enforce 'formatoptions' setting
local format_options = augroup('format_options', augroup_opts)

autocmd('BufEnter', {
  group = format_options,
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions
      - 't' -- don't wrap text using 'textwidth'
      + 'c' -- wrap comments using 'textwidth'
      + 'r' -- continue comments with newline in insert mode
      - 'o' -- don't continue comments with newline in normal mode
      + 'q' -- format comments with 'gq'
      - 'a' -- don't auto format text
      + 'n' -- format numbered lists
      + 'j' -- remove comment leaders when joining lines
  end,
})
