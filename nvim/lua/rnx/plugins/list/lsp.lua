return {
  -- Native LSP client configuration tool
  {
    'neovim/nvim-lspconfig',
    lazy = false,

    opts = {
      -- Options passed to `vim.diagnostic.config()`
      diagnostics = {
        underline = true,
        virtual_text = true,
        virtual_lines = false,
        signs = true,
        float = true,
        update_in_insert = false,
        severity_sort = true,
        jump = {
          float = true,
          wrap = true,
        },
      },

      -- Options passed to `vim.lsp.config()`
      servers = {
        lua_ls = {
          settings = { Lua = { hint = { enable = true } } },
        },

        ts_ls = {},
        html = {},
        cssls = {},
        tailwindcss = {},

        pyright = {},

        gopls = {},
      },
    },

    config = function(_, opts)
      -- Configure native diagnostics settings
      vim.diagnostic.config(opts.diagnostics)

      -- Configure language servers
      for server_name, server_opts in pairs(opts.servers) do
        vim.lsp.enable(server_name)
        vim.lsp.config(server_name, server_opts)
      end

      -- No longer creating keymaps for most LSP-related functions:
      -- * hover, signature help
      -- * goto definition, implementation, typedef, references
      -- * goto diagnostics
      -- * code action

      -- These keymaps are now created by default in Neovim 0.11
      -- SEE: `lsp-defaults` `default-mappings`

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

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
          local lsp_inlay_hints_supported = client:supports_method(lsp_inlay_hints_method, bufnr)

          if lsp_inlay_hints_supported then
            vim.keymap.set('n', 'grh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, { buffer = bufnr })
          end

          -- Enable code lens for language servers that support it
          local lsp_code_lens_method = vim.lsp.protocol.Methods.textDocument_codeLens
          local lsp_code_lens_supported = client:supports_method(lsp_code_lens_method, bufnr)

          if lsp_code_lens_supported then
            vim.lsp.codelens.refresh({ bufnr = bufnr })

            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
              buffer = bufnr,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
              end,
            })

            vim.keymap.set('n', 'grl', function()
              vim.lsp.codelens.run()
            end, { buffer = bufnr })
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
