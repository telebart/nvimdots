local function jsroot()
  if
    not vim.list_contains({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    }, vim.bo.filetype)
  then
    return
  end
  local root = vim.fs.root(0, { "package.json", ".git" })
  if root == nil then
    return
  end
  vim.g["test#project_root"] = root
end

local add = MiniDeps.add
add("sindrets/diffview.nvim")
require("diffview").setup({
  use_icons = false,
})

add("mbbill/undotree")
add("eandrju/cellular-automaton.nvim")
local build = function()
  vim.cmd("call mkdp#util#install()")
end
add({
  source = "iamcco/markdown-preview.nvim",
  hooks = {
    post_install = build,
    post_checkout = build,
  },
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
else
  vim.cmd([[
          function OpenMarkdownPreview (url)
          execute "silent ! firefox --new-window " . a:url
          endfunction
          let g:mkdp_browserfunc = 'OpenMarkdownPreview'
          ]])
end
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>")

add("uga-rosa/ccc.nvim")
require("ccc").setup({
  highlight_mode = "background",
  highlighter = {
    auto_enable = true,
    lsp = true,
  },
})
vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>")

add("vim-test/vim-test")
vim.g["test#strategy"] = "neovim_sticky"
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#preserve_screen"] = 0
vim.keymap.set("n", "<leader>tj", function()
  jsroot()
  vim.cmd("TestNearest | stopinsert")
end)
vim.keymap.set("n", "<leader>tf", function()
  jsroot()
  vim.cmd("TestFile | stopinsert")
end)
vim.keymap.set("n", "<leader>tk", function()
  vim.cmd("TestLast | stopinsert")
end)
