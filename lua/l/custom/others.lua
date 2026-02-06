require("diffview").setup({
  use_icons = false,
  enhanced_diff_hl = true,
})

vim.g.mkdp_auto_close = 0
vim.g.mkdp_theme = "dark"
vim.g.mkdp_browser = "firefox"
vim.g.mkdp_combine_preview = 1
vim.g.mkdp_filetypes = { "markdown", "plantuml", "asciidoc" }
if vim.fn.has("mac") == 1 then
  vim.cmd([[
        function OpenMarkdownPreview (url)
        execute "silent ! open -a Firefox -n --args --new-window " . a:url
        endfunction
        let g:mkdp_browserfunc = 'OpenMarkdownPreview'
        ]])
end
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>")

require("ccc").setup({
  highlight_mode = "background",
  highlighter = {
    auto_enable = true,
    lsp = true,
  },
})
vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>")

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
