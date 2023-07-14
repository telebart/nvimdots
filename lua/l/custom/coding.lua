return {

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
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
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
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
          {name = 'path'},
          {name = 'nvim_lsp'},
          {name = 'buffer', keyword_length = 3},
          {name = 'luasnip', keyword_length = 2},
        }),
        sorting = defaults.sorting,
      }
    end,
  },

  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
}

