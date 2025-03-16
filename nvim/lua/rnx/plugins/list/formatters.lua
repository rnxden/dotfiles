return {
  -- Formatter configuration tool
  {
    'stevearc/conform.nvim',

    cmd = 'ConformInfo',
    event = 'BufWritePre',
    keys = {
      {
        'gf',
        function()
          require('conform').format({ async = true })
        end,
      },
    },

    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
      },

      format_on_save = {
        async = false,
        timeout_ms = 500,
      },
    },

    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}
