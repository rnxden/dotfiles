return {
  -- Customizable statusline
  {
    'nvim-lualine/lualine.nvim',

    dependencies = {
      'nvim-tree/nvim-web-devicons', -- icons
      'catppuccin/nvim', -- colors
    },

    event = 'VeryLazy',

    config = function()
      local colors = require('catppuccin.palettes').get_palette(require('catppuccin').options.flavour)

      local fg_active_color = colors.text
      local fg_inactive_color = colors.overlay0
      local bg_color = colors.surface0

      local mode_colors = {
        -- Normal mode
        ['n'] = colors.blue,
        ['no'] = colors.blue,

        -- Operator pending modes
        ['r'] = colors.blue,
        ['rm'] = colors.blue,
        ['r?'] = colors.blue,

        -- Insert mode
        ['i'] = colors.green,
        ['ic'] = colors.green,

        -- Terminal mode
        ['t'] = colors.green,

        -- Visual mode
        ['v'] = colors.mauve,
        ['V'] = colors.mauve,
        [''] = colors.mauve,

        -- Command mode
        ['c'] = colors.teal,
        ['cv'] = colors.teal,

        -- Replace mode
        ['R'] = colors.red,
        ['Rv'] = colors.red,

        -- Select mode
        ['s'] = colors.peach,
        ['S'] = colors.peach,
        [''] = colors.peach,
      }

      local filename_color = colors.lavender
      local filename_modified_color = colors.peach

      local fileformat_color = colors.flamingo

      local gitbranch_color = colors.pink

      -- Configure native statusline settings
      vim.opt.showmode = false
      vim.opt.showcmd = true

      -- Configure statusline
      local opts = {
        options = {
          -- Disable separators
          component_separators = '',
          section_separators = '',

          -- Create statusline for each window
          globalstatus = false,
        },
      }

      -- Configure statusline theme
      opts.options.theme = {}

      opts.options.theme.normal = {}
      opts.options.theme.normal.c = {
        fg = fg_active_color,
        bg = bg_color,
      }

      opts.options.theme.inactive = {}
      opts.options.theme.inactive.c = {
        fg = fg_inactive_color,
        bg = bg_color,
      }

      -- Clear all sections of default components
      for _, sections_type in ipairs({ 'sections', 'inactive_sections' }) do
        opts[sections_type] = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        }
      end

      -- Add custom components (we will only use the center sections, c and x)
      local function add_component(align, component_fn)
        local section_name = align == 'left' and 'lualine_c' or 'lualine_x'
        table.insert(opts.sections[section_name], component_fn(true))
        table.insert(opts.inactive_sections[section_name], component_fn(false))
      end

      -- mode component
      add_component('left', function(active)
        return {
          function()
            return '▊'
          end,

          color = function()
            return {
              fg = active and mode_colors[vim.fn.mode()] or fg_inactive_color,
            }
          end,

          padding = {
            right = 1,
          },
        }
      end)

      -- icon component
      add_component('left', function()
        return {
          function()
            return '宇'
          end,

          padding = {
            right = 1,
          },

          color = {
            gui = 'bold',
          },
        }
      end)

      -- file type component
      add_component('left', function(active)
        return {
          'filetype',
          colored = active,
          icon_only = true,

          padding = {
            right = 0,
          },
        }
      end)

      -- file name component
      add_component('left', function(active)
        return {
          'filename',
          file_status = false, -- don't display file status (readonly, modified)
          newfile_status = false, -- don't display new file status
          path = 1, -- display relative path

          symbols = {
            unnamed = '*unnamed file*',
          },

          color = function()
            return {
              fg = active and (vim.bo.modified and filename_modified_color or filename_color) or fg_inactive_color,
              gui = 'bold',
            }
          end,

          padding = {
            right = 2,
          },
        }
      end)

      -- cursor location component
      add_component('left', function()
        return {
          'location',

          padding = {
            right = 1,
          },
        }
      end)

      -- cursor progress component
      add_component('left', function()
        return {
          'progress',

          padding = {
            right = 1,
          },
        }
      end)

      -- diagnostics component
      add_component('left', function(active)
        return {
          'diagnostics',
          colored = active,
          sources = { 'nvim_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },

          padding = {
            left = 1,
          },
        }
      end)

      -- file encoding component
      add_component('right', function(active)
        return {
          'o:encoding',

          fmt = string.upper,
          color = {
            fg = active and fileformat_color or fg_inactive_color,
          },

          padding = {
            right = 1,
          },
        }
      end)

      -- file format component
      add_component('right', function(active)
        return {
          'o:fileformat',

          fmt = string.upper,
          color = {
            fg = active and fileformat_color or fg_inactive_color,
          },

          padding = {
            right = 1,
          },
        }
      end)

      -- git branch component
      add_component('right', function(active)
        return {
          'branch',
          icon = '',

          color = {
            fg = active and gitbranch_color or fg_inactive_color,
          },

          padding = {
            right = 1,
          },
        }
      end)

      -- git diff component
      add_component('right', function(active)
        return {
          'diff',
          colored = active,
          symbols = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },

          padding = {
            right = 1,
          },
        }
      end)

      require('lualine').setup(opts)
    end,
  },
}
