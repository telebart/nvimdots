vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>pq", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
local on_jump = function()
  vim.diagnostic.open_float(nil, { focus = false })
end
vim.keymap.set('n', '<leader>k', function() vim.diagnostic.jump({count=-1, on_jump=on_jump}) end)
vim.keymap.set('n', '<leader>j', function() vim.diagnostic.jump({count=1, on_jump=on_jump}) end)
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

vim.lsp.semantic_tokens.enable(false)

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local ts = {
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
  }
}
vim.lsp.config["vtsls"] = ts
vim.lsp.config["tsgo"] = ts
vim.lsp.config['jsonls'] = {
  filetype = { "json", "jsonc", "json5" },
  settings = {
    json = {
      validate = { enable = true },
      schemas = require("schemastore").json.schemas(),
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

require("mason").setup({})

vim.lsp.enable({
  "bashls",
  "gopls",
  "emmylua_ls",
  "ols",
  "tsgo",
  "jsonls",
  "yamlls",
})
