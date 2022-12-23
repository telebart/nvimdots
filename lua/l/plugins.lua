vim.g.mapleader = " "
vim.g.maplocalleader = " "
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "http://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  "jose-elias-alvarez/null-ls.nvim"
  ,{
    "williamboman/mason.nvim"
    ,"williamboman/mason-lspconfig.nvim"
    ,"neovim/nvim-lspconfig"
    ,"folke/neodev.nvim"
  }

  ,"hrsh7th/nvim-cmp"
  ,"hrsh7th/cmp-nvim-lsp"
  ,"hrsh7th/cmp-buffer"
  ,"saadparwaiz1/cmp_luasnip"
  ,"hrsh7th/cmp-path"

  ,{
    "L3MON4D3/LuaSnip"
  }
  ,"rafamadriz/friendly-snippets"

  ,"lewis6991/gitsigns.nvim"

  ,"is0n/fm-nvim"

  ,{
    "nvim-treesitter/nvim-treesitter"
    ,config = function() pcall(require("nvim-treesitter.install").update()) end
  }
  ,{
    "nvim-treesitter/nvim-treesitter-context"
  }
  ,{
    "nvim-treesitter/nvim-treesitter-textobjects"
  }

  ,"nvim-lua/popup.nvim"
  ,"nvim-lua/plenary.nvim"

  ,"nvim-telescope/telescope.nvim"
  ,{
    "nvim-telescope/telescope-fzf-native.nvim"
    ,build = "make"
    ,cond = function() return vim.fn.executable "make" == 1 end
  }

  ,"mbbill/undotree"

  ,"airblade/vim-rooter"
  ,"cljoly/telescope-repo.nvim"

  ,"norcalli/nvim-colorizer.lua"
  ,"folke/lsp-colors.nvim"

  ,{
    "folke/tokyonight.nvim"
    ,priority = 1000
  }

  ,{
    "iamcco/markdown-preview.nvim"
    ,config = function() vim.fn["mkdp#util#install"]() end
    ,event = "BufAdd *.md"
  }

  ,"rebelot/heirline.nvim"
  ,"j-hui/fidget.nvim"

  ,"klen/nvim-test"

  ,"theprimeagen/harpoon"

  ,"asiryk/auto-hlsearch.nvim"
  ,"olexsmir/gopher.nvim"

  ,{
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
    },
  }
  ,{
    'numToStr/Comment.nvim'
    ,config = function() require('Comment').setup() end
}
})

require("neodev").setup()
