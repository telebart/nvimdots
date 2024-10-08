---@diagnostic disable: missing-fields
return function (add)
  add("hrsh7th/nvim-cmp")
  add("saadparwaiz1/cmp_luasnip")
  add({
    source ="L3MON4D3/LuaSnip",
    hooks = { post_checkout = function() os.execute("make install_jsregexp") end },
  })
  add("rafamadriz/friendly-snippets")
  add("mfussenegger/nvim-lint")
  add('stevearc/conform.nvim')
  -- add({
  --   source = "Saghen/blink.cmp",
  --   checkout = "v0.2.0",
  --   monitor = "main"
  -- })
  add("telebart/blink.cmp")
  require("blink.cmp").setup({
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    fuzzy = {
      use_frecency = false
    },
    keymap = {
      show = "<C-e>",
      select_next = "<C-n>",
      select_prev = "<C-p>",
      snippet_forward = "<C-j>",
      snippet_backward = "<C-k>",
      scroll_documentation_down = "<C-d>",
      scroll_documentation_up = "<C-u>",
    },
    windows = {
      autocomplete = {
        border = "rounded",
        draw = "reversed",
      },
      documentation = {
        border = "rounded",
      },
    },
    sources = {
      providers = {
        {
          { 'blink.cmp.sources.lsp' },
          { 'blink.cmp.sources.path' },
          { 'blink.cmp.sources.snippets', score_offset = -3 },
        },
      }
    }
  })

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
          "--organize-imports-enabled=false",
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
