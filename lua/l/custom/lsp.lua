return function (add)
  add("neovim/nvim-lspconfig")
  add("williamboman/mason.nvim")
  add("williamboman/mason-lspconfig.nvim")

  vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist)
  vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>k', function() vim.diagnostic.jump({count = -1}) end)
  vim.keymap.set('n', '<leader>j', function() vim.diagnostic.jump({count = 1}) end)
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
    vtsls = {
      settings = {
        typescript = {
          preferences = {
            importModuleSpecifier = "non-relative",
          },
        },
      }
    },
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
    jsonls = {
      on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
      end,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    yamlls = {
      on_new_config = function(new_config)
        new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
      end,
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas({
            replace = {
              ['gitlab-ci'] = {
                description = 'Gitlab CI',
                fileMatch = { '.gitlab*yml', 'gitlab*yml', '.snyk.yml' },
                name = "gitlab-ci",
                url = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"
              }
            },
          }),
        },
      },
    },
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()

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
end
