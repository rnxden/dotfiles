return {
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',

    event = 'BufReadPost',

    opts = {
      scope = {
        enabled = false,
      },
    },

    config = function(_, opts)
      require('ibl').setup(opts)
    end,
  },

  -- Document highlights
  {
    'RRethy/vim-illuminate',

    event = 'BufReadPost',

    keys = {
      {
        ']]',
        function()
          require('illuminate').goto_next_reference()
        end,
      },
      {
        '[[',
        function()
          require('illuminate').goto_prev_reference()
        end,
      },
    },

    opts = {
      providers = { 'lsp', 'treesitter' },
    },

    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },

  -- Sign column git status
  {
    'lewis6991/gitsigns.nvim',

    event = 'BufReadPost',

    opts = {},

    config = function(_, opts)
      require('gitsigns').setup(opts)
    end,
  },
}
