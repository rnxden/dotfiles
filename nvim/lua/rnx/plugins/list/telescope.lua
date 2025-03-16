return {
  -- Highly extensible fuzzy finder
  {
    'nvim-telescope/telescope.nvim',

    dependencies = {
      'nvim-lua/plenary.nvim', -- utils
      'nvim-tree/nvim-web-devicons', -- icons

      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- sorter
    },

    cmd = 'Telescope',
    keys = {
      {
        '<leader>f',
        function()
          require('telescope.builtin').find_files({
            hidden = true,
            no_ignore = false,
            no_ignore_parent = false,
            file_ignore_patterns = {
              '%.git$',
              '%.git/',
            },
          })
        end,
      },

      {
        '<leader>F',
        function()
          require('telescope.builtin').find_files({
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
          })
        end,
      },

      {
        '<leader>g',
        function()
          vim.ui.input({ prompt = 'Grep String: ' }, function(input)
            if input then
              require('telescope.builtin').grep_string({
                search = input,
                additional_args = { '--hidden' },
                file_ignore_patterns = {
                  '%.git$',
                  '%.git/',
                },
              })
            end
          end)
        end,
      },

      {
        '<leader>G',
        function()
          vim.ui.input({ prompt = 'Grep String (All Files): ' }, function(input)
            if input then
              require('telescope.builtin').grep_string({
                search = input,
                additional_args = { '--hidden', '--no-ignore' },
              })
            end
          end)
        end,
      },

      {
        '<leader>l',
        function()
          require('telescope.builtin').live_grep({
            additional_args = { '--hidden' },
            file_ignore_patterns = {
              '%.git$',
              '%.git/',
            },
          })
        end,
      },

      {
        '<leader>L',
        function()
          require('telescope.builtin').live_grep({
            additional_args = { '--hidden', '--no-ignore' },
          })
        end,
      },

      {
        '<leader>h',
        function()
          require('telescope.builtin').help_tags()
        end,
      },

      {
        '<leader>H',
        function()
          require('telescope.builtin').man_pages()
        end,
      },
    },

    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
    },

    config = function(_, opts)
      local telescope = require('telescope')

      -- Disable default keymaps
      local default_mappings = require('telescope.mappings').default_mappings

      for _, mode in ipairs({ 'i', 'n' }) do
        for mapping in pairs(default_mappings[mode]) do
          default_mappings[mode][mapping] = nil
        end
      end

      -- Add custom keymaps to options table
      local actions = require('telescope.actions')

      local mappings_dual = {
        ['<CR>'] = actions.select_default,
        ['<C-s>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,
        ['<C-f>'] = actions.preview_scrolling_right,
        ['<C-b>'] = actions.preview_scrolling_left,

        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key, -- sometimes sent when pressing CTRL+/
      }

      local mappings_insert = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,

        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,

        ['<C-w>'] = { '<C-S-w>', type = 'command' }, -- fixes CTRL+W not working for some reason
      }

      local mappings_normal = {
        ['<Esc>'] = actions.close,
        ['<C-c>'] = actions.close,

        ['<Tab>'] = actions.toggle_selection,

        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
      }

      local mappings = {
        i = vim.tbl_extend('error', mappings_dual, mappings_insert),
        n = vim.tbl_extend('error', mappings_dual, mappings_normal),
      }

      opts.defaults = opts.defaults or {}
      opts.defaults.mappings = mappings

      -- Setup telescope and load extensions
      telescope.setup(opts)
      telescope.load_extension('fzf')
    end,
  },
}
