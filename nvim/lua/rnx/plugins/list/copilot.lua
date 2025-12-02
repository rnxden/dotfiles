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
          accept = '<M-y>',
          accept_word = false,
          accept_line = false,
          next = '<M-n>',
          prev = '<M-p>',
          dismiss = '<M-e>',
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
