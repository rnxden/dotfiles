return {
  -- Native treesitter client configuration tool
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main', -- TODO: Remove this after 'main' becomes the official default branch (SEE: f976acd)

    opts = {},

    config = function(_, opts)
      local treesitter = require('nvim-treesitter')
      treesitter.setup(opts)

      -- Install language parsers
      local ensure_installed = {
        -- nvim
        'vim',
        'vimdoc',
        'lua',
        'luadoc',
        'luap',

        -- js/ts
        'javascript',
        'typescript',
        'jsx',
        'tsx',
        'jsdoc',

        -- python
        'python',

        -- golang
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'gowork',
      }

      treesitter.install(ensure_installed):wait()
      treesitter.update()

      -- Enable treesitter highlighting
      local ensure_installed_filetypes = {}

      for _, lang in pairs(ensure_installed) do
        local filetypes = vim.treesitter.language.get_filetypes(lang)
        vim.list_extend(ensure_installed_filetypes, filetypes)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
        pattern = ensure_installed_filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
