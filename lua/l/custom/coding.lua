local add = MiniDeps.add
add("iguanacucumber/magazine.nvim")
add("saadparwaiz1/cmp_luasnip")
add({
  source ="L3MON4D3/LuaSnip",
  hooks = { post_checkout = function() os.execute("make install_jsregexp") end },
})
add("rafamadriz/friendly-snippets")
add("mfussenegger/nvim-lint")
add('stevearc/conform.nvim')

local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.setup({
  history = true,
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave',
  update_events = { "TextChanged", "TextChangedI" }
})
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
  completion = { completeopt = "menu,menuone,noinsert" },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<TAB>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Insert}),
    ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
    ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
    ['<C-e>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end),
    ['<C-j>'] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
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
require('lint').linters.eslint_d.args = vim.list_extend({"--rule", "prettier/prettier: 0"}, require('lint').linters.eslint_d.args)
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
    print("lint disabled")
  else
    print("lint enabled")
  end
  lint = not lint
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
