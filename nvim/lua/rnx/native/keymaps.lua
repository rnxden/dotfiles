local map = vim.keymap.set

-- Enter normal mode using more accessible keys
local non_terminal_modes = { 'n', 'v', 's', 'x', 'o', 'i' }
local terminal_modes = { 't' }

map(non_terminal_modes, '<C-c>', '<Esc>', { remap = true }) -- ctrl+c in most modes
map(terminal_modes, '<C-q>', '<C-\\><C-n>') -- ctrl+q in terminal mode

-- Switch to previous buffer
map('n', 'gb', '<C-^>')

-- Send j/k movements to jumplist when a count is used
map('n', 'j', function()
  return (vim.v.count > 0 and ("m'" .. vim.v.count) or '') .. 'j'
end, { expr = true })

map('n', 'k', function()
  return (vim.v.count > 0 and ("m'" .. vim.v.count) or '') .. 'k'
end, { expr = true })

-- Copy to system register
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>Y', '"+Y')

-- Paste from system register
map({ 'n', 'v' }, '<leader>p', '"+p')
map({ 'n', 'v' }, '<leader>P', '"+P')

-- Delete without replacing register contents
map({ 'n', 'v' }, '<leader>d', '"_d')
map({ 'n', 'v' }, '<leader>D', '"_D')

-- Center cursor when navigating
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

map('n', '<C-f>', '<C-f>zz')
map('n', '<C-b>', '<C-b>zz')
