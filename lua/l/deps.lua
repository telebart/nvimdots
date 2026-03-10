require("vim._core.ui2").enable({enable = true, msg = { target = "msg", }})

vim.pack.add({
  "https://github.com/Punity122333/hexinspector.nvim.git",
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/eandrju/cellular-automaton.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/uga-rosa/ccc.nvim",
  "https://github.com/vim-test/vim-test",
  "https://github.com/williamboman/mason.nvim",
})

vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  local name = ev.data.spec.name
  if name == "nvim-treesitter" then
    vim.cmd("TSUpdate")
  elseif name == "markdown-preview.nvim" then
    vim.cmd("call mkdp#util#install()")
  end
end })

require("l.custom.lsp")
require("l.custom.mininow")
require("l.custom.treesitter")
vim.schedule(function()
  require("l.custom.coding")
  require("l.custom.minilater")
  require("l.custom.mydap")
  require("l.custom.gitsigns")

  require("hexinspector").setup({})

  require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
  })

  -- markdown-preview.nvim
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_theme = "dark"
  vim.g.mkdp_browser = "firefox"
  vim.g.mkdp_combine_preview = 1
  vim.g.mkdp_filetypes = { "markdown", "plantuml", "asciidoc" }
  vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>")
  --

  require("ccc").setup({
    highlight_mode = "background",
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  })
  vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>")

  -- vim-test
  vim.g["test#strategy"] = "neovim_sticky"
  vim.g["test#neovim#term_position"] = "vert"
  vim.g["test#preserve_screen"] = 0
  vim.keymap.set("n", "<leader>tj", function()
    vim.cmd("TestNearest | stopinsert")
  end)
  vim.keymap.set("n", "<leader>tf", function()
    vim.cmd("TestFile | stopinsert")
  end)
  vim.keymap.set("n", "<leader>tk", function()
    vim.cmd("TestLast | stopinsert")
  end)
  --
end)

