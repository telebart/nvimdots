return {{

  -- "nvim-lua/popup.nvim",
  -- { "folke/neodev.nvim", opts = {} },
  "nvim-lua/plenary.nvim",

  "mbbill/undotree",

  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000 },

  {
    "iamcco/markdown-preview.nvim",
    config = function() vim.fn["mkdp#util#install"]() end,
    ft = {"markdown"}
  },

  { "brenoprata10/nvim-highlight-colors", opts = {} },

  {
    "j-hui/fidget.nvim",
    opts = { window = {blend = 0} }
  },

  {
    "chrishrb/gx.nvim",
    opts = {}
  },
  {
  "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context"
    }
  }
}}
