local add = MiniDeps.add
add("neovim/nvim-lspconfig")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("b0o/SchemaStore.nvim")

vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>k', function() vim.diagnostic.goto_prev() end)
vim.keymap.set('n', '<leader>j', function() vim.diagnostic.goto_next() end)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("l-lsp-attach", {clear = true}),
  callback = function (event)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
    vim.keymap.set("n", "K", vim.lsp.buf.hover , { buffer = event.buf })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = event.buf })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
    vim.keymap.set("n", "<leader>GI", vim.lsp.buf.incoming_calls, { buffer = event.buf })
    vim.keymap.set("n", "<leader>GO", vim.lsp.buf.outgoing_calls, { buffer = event.buf })
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help , { buffer = event.buf })
  end
})

vim.diagnostic.config({
  float = { header = "", prefix = "", source = true},
  virtual_text = true,
})

vim.lsp.config('*', {
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
vim.lsp.config['vtsls'] = {
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
  }
}
vim.lsp.config['gopls'] = {
  settings = {
    gopls = {
      buildFlags = { "-tags", "test,account_test" },
    },
  },
}
vim.lsp.config['jsonls'] = {
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
}
vim.lsp.config['yamlls'] = {
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
}

require("mason").setup({})
require("mason-lspconfig").setup({})
