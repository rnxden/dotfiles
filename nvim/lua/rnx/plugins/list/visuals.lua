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
}
