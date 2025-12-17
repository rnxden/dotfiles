return {
  {
    'zbirenbaum/copilot.lua',

    cmd = 'Copilot',
    event = 'InsertEnter',

    opts = {
      panel = {
        enabled = false,
      },

      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<C-s>',
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = '<C-g>',
        },
      },

      nes = {
        enabled = false,
      },
    },

    config = function(_, opts)
      require('copilot').setup(opts)
    end,
  },
}
