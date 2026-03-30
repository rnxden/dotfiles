return {
  -- Formatter configuration tool
  {
    'stevearc/conform.nvim',

    cmd = 'ConformInfo',
    event = 'BufWritePre',
    keys = {
      {
        'grf',
        function()
          require('conform').format({ async = true })
        end,
      },
    },

    opts = {
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
    },

    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}
