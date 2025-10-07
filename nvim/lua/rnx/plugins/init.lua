-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazy_lock = vim.fn.stdpath('config') .. '/lazy_lock.json'

if not vim.uv.fs_stat(lazy_path) then
  local process = vim
    .system(
      { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazy_path },
      { text = true }
    )
    :wait()

  if process.code ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { process.stderr, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazy_path)

-- Initialize and configure lazy.nvim
local lazy = require('lazy')

lazy.setup({ import = 'rnx.plugins.list' }, {
  defaults = {
    lazy = true, -- lazy load plugins by default
  },

  local_spec = false, -- don't load project specific .lazy.lua spec files
  lockfile = lazy_lock, -- change plugin lockfile path

  install = {
    missing = true, -- auto install missing plugins
    colorscheme = { 'catppuccin', 'default' }, -- load colorschemes if available
  },

  change_detection = {
    enabled = false, -- don't detect config changes
  },

  readme = {
    enabled = false, -- don't generate helptags from readme files
  },

  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        --'matchit',
        --'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

-- Display startup time after loading
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyVimStarted',
  group = vim.api.nvim_create_augroup('startup_time', { clear = true }),
  callback = vim.schedule_wrap(function()
    local stats = lazy.stats()
    local stats_msg = string.format('Loaded with %d plugins in %.2fms', stats.count, stats.startuptime)
    vim.notify(stats_msg, vim.log.levels.INFO)
  end),
})
