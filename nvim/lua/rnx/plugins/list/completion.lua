return {
  -- Completion engine
  {
    -- TODO: blink.cmp is in beta and gets frequent updates and/or breaking changes. Update and configure regularly.
    'saghen/blink.cmp',
    version = '*',

    dependencies = {
      'echasnovski/mini.icons', -- icons
    },

    event = { 'InsertEnter', 'CmdlineEnter' },

    -- Because of the deeply nested nature of blink.cmp's config and documentation, a function is more suitable here.
    opts = function()
      ---@type blink.cmp.Config
      local opts = {}

      -- Configuration > Completion
      opts.completion = {}

      -- Configuration > Completion > List
      opts.completion.list = {}
      opts.completion.list.selection = {
        preselect = true, -- select first item
        auto_insert = false, -- don't insert selected item
      }

      -- Configuration > Completion > Menu
      opts.completion.menu = {}
      opts.completion.menu.scrolloff = 0 -- wtf why is this 2 by default
      opts.completion.menu.draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },

        components = {
          -- Use kind icons from mini.icons
          kind_icon = {
            ellipsis = false,

            text = function(ctx)
              local icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return icon
            end,

            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
        },
      }

      -- Configuration > Completion > Documentation
      opts.completion.documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
      }

      -- Configuration > Completion > Ghost Text
      opts.completion.ghost_text = {
        enabled = true,
      }

      -- Configuration > Keymap
      opts.keymap = {
        preset = 'none',

        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'cancel' },

        ['<C-n>'] = { 'show', 'select_next' },
        ['<C-p>'] = { 'show', 'select_prev' },

        ['<C-f>'] = { 'scroll_documentation_down' },
        ['<C-b>'] = { 'scroll_documentation_up' },

        ['<C-j>'] = { 'snippet_forward' },
        ['<C-k>'] = { 'snippet_backward' },
      }

      -- Configuration > Signature
      opts.signature = {
        enabled = true,
      }

      -- Configuration > Sources
      opts.sources = {
        default = { 'lsp', 'path', 'buffer' },
      }

      -- Modes > Cmdline
      opts.cmdline = {}
      opts.cmdline.enabled = true

      opts.cmdline.completion = {}
      opts.cmdline.completion.list = {}
      opts.cmdline.completion.list.selection = {
        preselect = true, -- select first item
        auto_insert = true, -- insert selected item
      }

      opts.cmdline.keymap = {
        preset = 'none',

        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'cancel' },

        ['<Tab>'] = { 'show_and_insert', 'select_next' },
        ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
      }

      return opts
    end,

    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  },
}
