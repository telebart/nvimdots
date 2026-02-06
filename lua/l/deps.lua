require("vim._core.ui2").enable({enable = true, msg = { target = "msg", }})

vim.pack.add({
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/eandrju/cellular-automaton.nvim",
  "https://github.com/iamcco/markdown-preview.nvim", -- vim.cmd("call mkdp#util#install()")
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter", -- hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/uga-rosa/ccc.nvim",
  "https://github.com/vim-test/vim-test",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/stevearc/conform.nvim",
})

vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  local name = ev.data.spec.name
  if name == "nvim-treesitter" then
    vim.cmd("TSUpdate")
  end
  if name == "markdown-preview.nvim" then
    vim.cmd("call mkdp#util#install()")
  end
end })

require("l.custom.lsp")
require("l.custom.mininow")
require("l.custom.treesitter")
require("l.custom.coding")
require("l.custom.minilater")
require("l.custom.mydap")
require("l.custom.gitsigns")
require("l.custom.others")

