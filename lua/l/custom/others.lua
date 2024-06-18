local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local function jsroot()
  if not contains({
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  }, vim.bo.filetype) then return end
  local root = vim.fs.root(0, {'package.json', '.git'})
  if root == nil then return end
  vim.g["test#project_root"] = root
end

return function (add, later)
  add("sindrets/diffview.nvim")
  require("diffview").setup({
    use_icons = false
  })

  add("mbbill/undotree")
  add("eandrju/cellular-automaton.nvim")
  local build = function() vim.cmd('call mkdp#util#install()') end
  add({
    source = 'iamcco/markdown-preview.nvim',
    hooks = {
      post_install = function() later(build) end,
      post_checkout = build,
    },
  })
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_browser = "firefox"
  vim.g.mkdp_combine_preview = 1
  vim.g.mkdp_filetypes = { "markdown", "plantuml" }
  if vim.fn.has("mac") == 1 then
    vim.cmd[[
        function OpenMarkdownPreview (url)
        execute "silent ! open -a Firefox -n --args --new-window " . a:url
        endfunction
        let g:mkdp_browserfunc = 'OpenMarkdownPreview'
        ]]
  else
    vim.cmd[[
          function OpenMarkdownPreview (url)
          execute "silent ! firefox --new-window " . a:url
          endfunction
          let g:mkdp_browserfunc = 'OpenMarkdownPreview'
          ]]
  end
  vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>")

  add("uga-rosa/ccc.nvim")
  require("ccc").setup({
    highlight_mode = "virtual",
    virtual_pos = "inline-right",
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
  vim.keymap.set("n", "<leader>tj", function ()
    jsroot()
    vim.cmd("TestNearest | stopinsert")
  end)
  vim.keymap.set("n", "<leader>tf", function ()
    jsroot()
    vim.cmd("TestFile | stopinsert")
  end)
  vim.keymap.set("n", "<leader>tk", function()
    vim.cmd("TestLast | stopinsert")
  end)
end
