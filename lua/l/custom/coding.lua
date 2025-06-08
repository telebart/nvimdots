local add = MiniDeps.add
add("rafamadriz/friendly-snippets")
add("mfussenegger/nvim-lint")
add('stevearc/conform.nvim')
add({
  source = "https://github.com/Saghen/blink.cmp",
  checkout = "v1.3.1",
})

require("blink.cmp").setup({
  cmdline = { enabled = false },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 50 },
    ghost_text = { enabled = false },
    list = { selection = { preselect = true, auto_insert = false } },
    menu = {
      max_height = 20,
      draw = {
        columns = { { "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
  sources = {
    default = { 'lsp' },
  },
  keymap = {
    ["<C-space>"] = {},
    ["<C-s>"] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
    ["<TAB>"] = { "accept", "fallback" },
    ["<C-j>"] = { "snippet_forward", "fallback" },
    ["<C-k>"] = { "snippet_backward", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ["<C-e>"] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.hide()
        else
          cmp.show()
        end
      end
    }
  }
})

require('lint').linters_by_ft = {
  go = {"golangcilint"},
  javascript = {"eslint_d"},
  javascriptreact = {"eslint_d"},
  typescript = {"eslint_d"},
  typescriptreact = {"eslint_d"},
  terraform = {"snyk_iac"},
}

local lint = true
vim.list_extend(require('lint').linters.eslint_d.args, {"--rule", "prettier/prettier: 0"})
vim.schedule(function() vim.list_extend(require('lint').linters.golangcilint.args, {"--fix=false"}) end, 1000)
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    if not lint then return end
    require("lint").try_lint()
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
  print("lint: " .. (lint and "enabled" or "disabled"))
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
