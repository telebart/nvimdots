return function (add)
  add("hrsh7th/nvim-cmp")
  add("hrsh7th/cmp-nvim-lsp")
  add("neovim/nvim-lspconfig")
  add("williamboman/mason.nvim")
  add("williamboman/mason-lspconfig.nvim")
  add("saadparwaiz1/cmp_luasnip")
  add({
    source ="L3MON4D3/LuaSnip",
    hooks = { post_checkout = function() os.execute("make install_jsregexp") end },
  })
  add("rafamadriz/friendly-snippets")

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
      { name = 'luasnip' },
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

  add("mfussenegger/nvim-lint")
  require('lint').linters_by_ft = {
    -- go = {"golangcilint"},
    -- javascript = {"eslint_d"},
    -- javascriptreact = {"eslint_d"},
    -- typescript = {"eslint_d"},
    -- typescriptreact = {"eslint_d"},
    terraform = {"snyk_iac"},
  }
  -- require('lint').linters.eslint_d.args = vim.list_extend({"--rule", "prettier/prettier: 0"}, require('lint').linters.eslint_d.args)
  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })

  add('stevearc/conform.nvim')
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
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
      graphql = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      xml = { "xmlformat" },
    },
    formatters = {
      biome = {
        command = "biome",
        args = {
          "check",
          "--trailing-comma=all",
          "--semicolons=as-needed",
          "--indent-style=space",
          "--indent-width=2",
          "--line-width=100",
          "--quote-style=single",
          "--apply",
          "--stdin-file-path",
          "$FILENAME",
        },
        formatStdin = true,
      },
    }
  })
end
