return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Mappings.
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist, opts)
      vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist, opts)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
      local on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", bufopts)
        vim.keymap.set({ "i", "n" }, "<C-h>", vim.lsp.buf.signature_help, bufopts)
      end

      vim.diagnostic.config({ float = { border = "rounded", header = "", prefix = "", source = true} })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      vim.defer_fn(function ()
        require("mason").setup()
        require("mason-lspconfig").setup()

        function Init_mason_bins()
          local bins = {
            "bash-language-server",
            "css-lsp",
            "delve",
            "dockerfile-language-server",
            "gofumpt",
            "golangci-lint",
            "gomodifytags",
            "gopls",
            "gotests",
            "gotestsum",
            "graphql-language-service-cli",
            "html-lsp",
            "json-lsp",
            "lua-language-server",
            "ols",
            "prettier",
            "pyright",
            "shellcheck",
            "shfmt",
            "sql-formatter",
            "sqlls",
            "stylua",
            "terraform-ls",
            "tflint",
            "vim-language-server",
            "vtsls",
          }
          vim.api.nvim_cmd({
            cmd = "MasonInstall",
            args = bins
          }, {})
        end

        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup_handlers({
          function (server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        })

        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        local servers = {
          zls = {},
          lua_ls = {
            settings = {
              Lua = {
                workspace = { checkThirdParty = false, },
                telemetry = { enable = false },
                library = {vim.env.VIMRUNTIME},
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

        for s, o in pairs(servers) do
          lspconfig[s].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = o.settings,
          })
        end
      end,0)
    end,
  },
}
