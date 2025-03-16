return {
  -- Replacement for vim.notify()
  {
    'j-hui/fidget.nvim',

    cmd = 'Fidget',

    opts = {
      progress = {
        display = {
          done_icon = ' ', -- use nerd font icon instead of emoji
        },
      },

      notification = {
        window = {
          winblend = 0, -- make background transparent
        },
      },
    },

    init = function()
      -- Create custom lazy loader to load the plugin when `vim.notify()` is called

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(...)
        require('lazy').load({ plugins = { 'fidget.nvim' } })
        return vim.notify(...)
      end
    end,

    config = function(_, opts)
      -- Setup fidget.nvim
      local fidget = require('fidget')
      fidget.setup(opts)

      vim.notify = fidget.notify

      -- Remove title from default notification groups
      fidget.notification.default_config.name = nil
      fidget.notification.default_config.icon = nil
      fidget.notification.default_config.priority = 0

      -- Create high priority notification group (negative priority shown at bottom)
      fidget.notification.set_config('priority', { priority = -1000, ttl = 7 }, true)
    end,
  },
}
