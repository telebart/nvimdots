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
    opts = { notification = { window = {winblend = 0} }}
  },

  {
    "chrishrb/gx.nvim",
    opts = {}
  },
}}
