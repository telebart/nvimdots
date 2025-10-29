local add = MiniDeps.add
add("rafamadriz/friendly-snippets")
add("mfussenegger/nvim-lint")
add('stevearc/conform.nvim')

require('lint').linters_by_ft = {
  go = {"golangcilint"},
  terraform = {"snyk_iac"},
}

local lint = true
if vim.fn.executable("golangci-lint") == 1 then
  vim.list_extend(require('lint').linters.golangcilint.args, {"--fix=false"})
end
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    if not lint then return end
    require("lint").try_lint(nil, {ignore_errors = true})
  end,
})
vim.keymap.set('n', '<leader>lt', function()
  if lint then
    local linters = require("lint").linters_by_ft[vim.bo.filetype]
    for _, l in ipairs(linters) do
      local ns = require("lint").get_namespace(l)
      vim.diagnostic.reset(ns)
    end
  end
  lint = not lint
  vim.notify("lint: " .. (lint and "enabled" or "disabled"))
end)
vim.keymap.set('n', '<leader>ff', function()
  require("conform").format({ lsp_fallback = true })
  vim.cmd('write')
end)
require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    sql = {"sql_formatter"},
    go = {"gofumpt"},
    sh = {"shfmt"},
    terraform = {"terraform_fmt"},
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    graphql = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    xml = { "xmlformat" },
    html = { "superhtml" },
  }
})
