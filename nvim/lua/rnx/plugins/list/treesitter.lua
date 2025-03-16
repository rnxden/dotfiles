return {
  -- Native treesitter client configuration tool
  {
    'nvim-treesitter/nvim-treesitter',

    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', -- textobjects
    },

    event = 'VeryLazy',

    build = ':TSUpdate',

    opts = function()
      local opts = {
        ensure_installed = {
          -- Neovim languages
          'vim',
          'vimdoc',
          'lua',
          'luadoc',
          'luap',

          -- Config languages
          'editorconfig',
          'json',
          'yaml',
          'toml',

          -- Tooling languages
          'query',
          'regex',
          'sql',
        },
        sync_install = false,
        auto_install = false,

        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<leader>v',
            node_incremental = '<leader>v',
            scope_incremental = false,
            node_decremental = false,
          },
        },

        indent = {
          enable = true,
        },

        textobjects = {
          select = { enable = false }, -- enabled and dynamically configured below
          swap = { enable = false },
          move = { enable = false }, -- enabled and dynamically configured below
          lsp_interop = { enable = false },
        },
      }

      local textobjects = {
        g = { '@assignment.rhs', '@assignment.rhs' },
        G = { '@assignment.lhs', '@assignment.lhs' },
        R = { '@attribute.inner', '@attribute.outer' },
        b = { '@block.inner', '@block.outer' },
        x = { '@call.inner', '@call.outer' },
        c = { '@class.inner', '@class.outer' },
        m = { '@comment.outer', '@comment.outer' }, -- @comment.inner is unsupported in most languages
        n = { '@conditional.inner', '@conditional.outer' },
        f = { '@function.inner', '@function.outer' },
        l = { '@loop.inner', '@loop.outer' },
        a = { '@parameter.inner', '@parameter.outer' },
        r = { '@return.inner', '@return.outer' },
      }

      opts.textobjects.select.enable = true
      opts.textobjects.select.keymaps = {}

      opts.textobjects.move.enable = true
      opts.textobjects.move.goto_next_start = {}
      opts.textobjects.move.goto_next_end = {}
      opts.textobjects.move.goto_previous_start = {}
      opts.textobjects.move.goto_previous_end = {}

      for key, textobject in pairs(textobjects) do
        local i = textobject[1]
        local a = textobject[2]

        opts.textobjects.select.keymaps['i' .. key] = i
        opts.textobjects.select.keymaps['a' .. key] = a

        opts.textobjects.move.goto_next_start[']' .. key] = a
        opts.textobjects.move.goto_next_end['g]' .. key] = a
        opts.textobjects.move.goto_previous_start['[' .. key] = a
        opts.textobjects.move.goto_previous_end['g[' .. key] = a
      end

      return opts
    end,

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
