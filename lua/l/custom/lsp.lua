return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- Mappings.
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<leader>qp', vim.diagnostic.setqflist, opts)
      vim.keymap.set('n', '<leader>pq', vim.diagnostic.setloclist, opts)
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      local on_attach = function(_, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', '<leader>ff', function ()
          vim.lsp.buf.format({
            filter = function(client)
              -- apply whatever logic you want (in this example, we'll only use null-ls)
              return client.name == "null-ls"
            end,
          })
        end, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", bufopts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, bufopts)
      end

      vim.diagnostic.config({
        float = {
          border = "rounded",
          header = "",
          prefix = "",
        },
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      {
        border = 'rounded',
      }
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      {
        border = 'rounded',
      }
      )

      require('mason-lspconfig').setup_handlers({
        function(server_name)
          require('lspconfig')[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end
      })

      require'lspconfig'.gopls.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            buildFlags =  {"-tags", require("l.dap-test").buildtags},
          }
        },
      }

      require'lspconfig'.zls.setup{
        on_attach = on_attach,
        capabilities = capabilities,
      }

      require'lspconfig'.ols.setup{
        on_attach = on_attach,
        capabilities = capabilities,
      }


      require'lspconfig'.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT', },
            diagnostics = { globals = {'vim'}, },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false, },
          },
        },
      }

      require'l.dap'
    end
  },
}
