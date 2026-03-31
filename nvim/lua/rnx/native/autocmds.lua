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
