return {
  -- Dark low-constrast colorscheme
  {
    'vague-theme/vague.nvim',

    opts = {
      bold = true,
      italic = false,

      on_highlights = function(highlights)
        highlights.Normal.bg = 'none'
        highlights.StatusLine.bg = 'none'
        highlights.StatusLineNC.bg = 'none'
        highlights.SignColumn.bg = 'none'
      end,
    },

    init = function()
      vim.cmd('colorscheme vague')
    end,

    config = function(_, opts)
      require('vague').setup(opts)
    end,
  },

  -- Minimal constrast-based colorscheme
  {
    'zenbones-theme/zenbones.nvim',

    dependencies = { 'rktjmp/lush.nvim' },

    --[[
    init = function()
      vim.g.zenwritten_italic_comments = false
      vim.g.zenwritten_italic_strings = false

      vim.cmd.colorscheme('zenwritten')

      local palette = require('zenbones.palette')

      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', fg = palette.dark.fg.hex })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none', fg = palette.dark.fg.darken(50).hex })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

      vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = palette.dark.blossom.hex })
    end,
    --]]
  },
}
