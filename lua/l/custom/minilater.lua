require("mini.notify").setup({})
require("mini.surround").setup()
require("mini.extra").setup()
require("mini.splitjoin").setup({
  mappings = {
    toggle = "gs"
  }
})
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "▎", },
  },
})
require("mini.git").setup()
vim.keymap.set({ "n", "x" }, "<Leader>gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>")

local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = {
    gen_loader.from_file(vim.fn.stdpath("data") .. "/site/pack/core/opt/friendly-snippets/snippets/global.json"),
    gen_loader.from_lang(),
  },
  mappings = {
    expand = "<C-s>",
    jump_next = "<C-j>",
    jump_prev = "<C-k>",
  },
})
