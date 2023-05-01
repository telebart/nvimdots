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
  vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, bufopts)
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
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
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

-- CMP

local luasnip = require('luasnip')


luasnip.config.set_config({
  history = true,
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave',
  updateevents = "TextChanged, TextChangedI"
})

vim.keymap.set({"i", "s"}, "<c-j>", function ()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end)

vim.keymap.set({"i", "s"}, "<c-k>", function ()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end)

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
  completion = { completeopt = 'menu,menuone,noinsert' },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    --['<C-Space>'] = cmp.mapping.complete(),
    --['<CR>'] = cmp.mapping.confirm({ behavior=cmp.ConfirmBehavior.Replace, select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    ['<TAB>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Select}),
    --['<C-j>'] = cmp.mapping.confirm({select = true}),
    --['<C-y>'] = cmp.mapping.confirm({select = true}),

    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select_opts),


    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
        fallback()
      else
        cmp.complete()
      end
    end),
  }),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  })
})

require'l.dap'
