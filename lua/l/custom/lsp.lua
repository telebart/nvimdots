local add = MiniDeps.add
add("neovim/nvim-lspconfig")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("b0o/SchemaStore.nvim")

vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>k', function() vim.diagnostic.jump({count=-1, float=true}) end)
vim.keymap.set('n', '<leader>j', function() vim.diagnostic.jump({count=1, float=true}) end)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("l-lsp-attach", {clear = true}),
  callback = function (event)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
    vim.keymap.set("n", "K", vim.lsp.buf.hover , { buffer = event.buf })
    vim.keymap.set("n", "<leader>GI", vim.lsp.buf.incoming_calls, { buffer = event.buf })
    vim.keymap.set("n", "<leader>GO", vim.lsp.buf.outgoing_calls, { buffer = event.buf })
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help , { buffer = event.buf })
  end
})

vim.diagnostic.config({
  float = { max_width = 100, source = true},
})

vim.lsp.log.set_level(vim.log.levels.OFF)
local capabilities = vim.tbl_deep_extend(
    "keep",
    require("mini.completion").get_lsp_capabilities(),
    vim.lsp.protocol.make_client_capabilities()
  )
capabilities.textDocument.completion.completionItem.snippetSupport = false
vim.lsp.config('*', {
  capabilities = capabilities,
})
vim.lsp.semantic_tokens.enable(false)

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.config["vtsls"] = {
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
  }
}
-- vim.lsp.enable("tsgo")
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
            url = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
          }
        },
      }),
    },
  },
}

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config["eslint"] = {
  on_attach = function(client, bufnr)
    if not base_on_attach then return end
    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
}

vim.lsp.config["copilot"] = {
  settings = {
    telemetry = {
      telemetryLevel = "none"
    }
  }
}
vim.lsp.inline_completion.enable(true)
vim.keymap.set("i", "<C-space>", function()
  vim.lsp.inline_completion.get()
  if vim.fn.pumvisible() == 1 then
    return "<C-e>"
  end
end, {
  expr = true,
  replace_keycodes = true,
})

require("mason").setup({})
require("mason-lspconfig").setup({})
