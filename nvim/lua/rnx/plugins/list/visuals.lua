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
