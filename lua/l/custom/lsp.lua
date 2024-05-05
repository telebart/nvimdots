return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist)
      vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)
      vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("l-lsp-attach", {clear = true}),
        callback = function (event)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = event.buf })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
          vim.keymap.set({ "i", "n" }, "<C-h>", vim.lsp.buf.signature_help, { buffer = event.buf })
        end
      })

      vim.diagnostic.config({ float = { border = "rounded", header = "", prefix = "", source = true} })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      local servers = {
        -- vtsls = {
        --   root_dir = require("lspconfig.util").root_pattern(".git")
        -- },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT", },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file('', true))
                },
              },
            }
          }
        },
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags", "test,account_test" },
              analyses = {
                unusedparams = true,
                nilness = true,
              },
            },
          },
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local lspconfig = require('lspconfig')
      lspconfig.util.default_config = vim.tbl_extend( "force", lspconfig.util.default_config,
        { on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end })

      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        }
      })
      lspconfig.zls.setup({})
    end,
  },
}
