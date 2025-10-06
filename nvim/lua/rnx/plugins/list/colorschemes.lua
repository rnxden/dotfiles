return {
  -- Dark low-constrast colorscheme
  {
    'vague2k/vague.nvim',

    opts = {
      bold = true,
      italic = false,
    },

    init = function()
      vim.cmd('colorscheme vague')

      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#242424' })
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

      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
    -]]
  },
}
