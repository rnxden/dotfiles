return {
  -- Soothing pastel colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin.nvim',

    opts = {
      flavour = 'mocha',

      -- The `transparent_background` option also makes floating windows transparent, which doesn't look good with the
      -- majority of plugin UIs, so we just set background-related highlights manually (see `custom_highlights` below)
      transparent_background = false,
      show_end_of_buffer = false, -- don't show '~' after the end of buffer
      term_colors = false, -- don't set terminal colors

      no_italic = true, -- don't allow italicized text
      no_bold = false, -- allow bolded text
      no_underline = false, -- allow underlined text

      custom_highlights = function(colors)
        return {
          Normal = { bg = colors.none },
          NormalNC = { bg = colors.none },

          WinSeparator = { link = 'LineNr' },

          StatusLine = { fg = colors.none, bg = colors.none },
          StatusLineNC = { fg = colors.none, bg = colors.none },
        }
      end,
    },

    init = function()
      vim.cmd.colorscheme('catppuccin')
    end,

    config = function(_, opts)
      require('catppuccin').setup(opts)
    end,
  },
}
