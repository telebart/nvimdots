return {

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      region_check_events = 'InsertEnter',
      delete_check_events = 'InsertLeave',
      updateevents = "TextChanged, TextChangedI"
    },
    keys = {
      {
        "<c-j>",
        function()
          if require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = {"i","s"},
      },
      {
        "<c-k>",
        function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end,
        mode = {"i","s"},
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = "menu,menuone,noinsert", },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<TAB>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Select}),
          ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
          ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
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
          {name = 'luasnip'},
          {name = 'nvim_lsp'},
        }),
        sorting = defaults.sorting,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function ()
      require('lint').linters_by_ft = {
          -- go = {"golangcilint"},
          fish = {"fish"},
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },
  {
    'stevearc/conform.nvim',
    config = function ()
      vim.keymap.set('n', '<leader>ff', function()
        require("conform").format({ lsp_fallback = true })
        vim.cmd('write')
      end)
      require("conform").setup({
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
          json = { "biome" },
          yaml = { "prettier" },
        },
      })
    end,
  },
}

