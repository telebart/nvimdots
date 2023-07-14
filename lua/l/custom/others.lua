return {{
    {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.terraform_fmt,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },

  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",

  "mbbill/undotree",

  "airblade/vim-rooter",

  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000 },

  {
    "iamcco/markdown-preview.nvim",
    config = function() vim.fn["mkdp#util#install"]() end,
    ft = {"markdown"}
  },

  {
    "olexsmir/gopher.nvim",
    opts = {
      commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "gotests",
        impl = "impl",
        iferr = "iferr",
      },
    }
  },

  { "norcalli/nvim-colorizer.lua", opts = {} },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    opts = {
      window = {
        relative = "win",         -- where to anchor, either "win" or "editor"
        blend = 0,              -- &winblend for the window
        zindex = nil,             -- the zindex value for the window
        border = "single",          -- style of border for the fidget window
      }
    }
  },

  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
  },
}}
