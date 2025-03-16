return {
  -- Native LSP client configuration tool
  {
    'neovim/nvim-lspconfig',

    dependencies = {
      'folke/lazydev.nvim', -- luals
      'saghen/blink.cmp', -- completions
      'nvim-telescope/telescope.nvim', -- keymaps
    },

    event = 'BufReadPost',

    opts = {
      -- Options passed to `vim.diagnostic.config()`
      diagnostics = {
        underline = true,
        virtual_text = true,
        signs = true,
        float = true,
        update_in_insert = false,
        severity_sort = true,
      },

      -- Options passed to `lspconfig[server].setup()`
      servers = {
        lua_ls = {
          settings = { Lua = { hint = { enable = true } } },
        },

        ts_ls = {},

        html = {},
        cssls = {},
      },
    },

    config = function(_, opts)
      -- Configure native diagnostics settings
      vim.diagnostic.config(opts.diagnostics)

      -- Configure language servers
      local lspconfig = require('lspconfig')

      for server_name, server_opts in pairs(opts.servers) do
        local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
        server_opts.capabilities = cmp_capabilities -- hook blink.cmp into lsp client

        lspconfig[server_name].setup(server_opts)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          -- Revert default modifications made by lspconfig (:help lsp-defaults)
          vim.bo[bufnr].omnifunc = nil
          vim.bo[bufnr].tagfunc = nil
          vim.bo[bufnr].formatexpr = nil
          pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })

          -- Create LSP-related keymaps
          local map = vim.keymap.set
          local map_opt = { buffer = args.buf }

          local function theme(picker) -- apply compact theme to telescope picker
            return function()
              picker(require('telescope.themes').get_dropdown())
            end
          end

          map('n', 'K', vim.lsp.buf.hover, map_opt)
          map('n', 'gs', vim.lsp.buf.signature_help, map_opt)

          map('n', 'gd', theme(require('telescope.builtin').lsp_definitions), map_opt)
          map('n', 'gD', vim.lsp.buf.declaration, map_opt) -- lol
          map('n', 'gr', theme(require('telescope.builtin').lsp_references), map_opt)
          map('n', 'gI', theme(require('telescope.builtin').lsp_implementations), map_opt)
          map('n', 'gy', theme(require('telescope.builtin').lsp_type_definitions), map_opt)

          map('n', '<leader>r', vim.lsp.buf.rename, map_opt)
          map('n', '<leader>a', vim.lsp.buf.code_action, map_opt)

          -- Enable document highlights for language servers that support it

          -- NOTE: Using vim-illuminate as an alternative until CursorHold stops relying on 'updatetime'
          --[[
          local lsp_document_highlights_method = vim.lsp.protocol.Methods.textDocument_documentHighlight
          local lsp_document_highlights_supported =
            client.supports_method(lsp_document_highlights_method, { bufnr = bufnr })

          if lsp_document_highlights_supported then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
          --]]

          -- Enable inlay hints toggling for language servers that support it
          local lsp_inlay_hints_method = vim.lsp.protocol.Methods.textDocument_inlayHint
          local lsp_inlay_hints_supported = client.supports_method(lsp_inlay_hints_method, { bufnr = bufnr })

          if lsp_inlay_hints_supported then
            map('n', '<leader>i', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, map_opt)
          end

          -- Enable code lens for language servers that support it
          local lsp_code_lens_method = vim.lsp.protocol.Methods.textDocument_codeLens
          local lsp_code_lens_supported = client.supports_method(lsp_code_lens_method, { bufnr = bufnr })

          if lsp_code_lens_supported then
            vim.lsp.codelens.refresh({ bufnr = bufnr })

            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
              buffer = bufnr,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },

  -- LuaLS configuration tool
  {
    'folke/lazydev.nvim',

    ft = 'lua',

    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },

    config = function(_, opts)
      require('lazydev').setup(opts)
    end,
  },
}
