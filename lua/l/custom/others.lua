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

return {
  "mbbill/undotree",
  {
    "eandrju/cellular-automaton.nvim",
    cmd = {"CellularAutomaton"},
  },
  {
    "iamcco/markdown-preview.nvim",
    build = vim.fn["mkdp#util#install"],
    ft = {"markdown"},
    config = function ()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_browser = "firefox"
      vim.g.mkdp_combine_preview = 1
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
    end
  },

  { "brenoprata10/nvim-highlight-colors", opts = {} },
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#strategy"] = "neovim_sticky"
      vim.g["test#neovim#term_position"] = "vert"
      vim.g["test#preserve_screen"] = 0
    end,
    keys = {
      { "<leader>tj", function ()
        jsroot()
        vim.cmd("TestNearest | stopinsert")
      end },
      { "<leader>tf", function ()
        jsroot()
        vim.cmd("TestFile | stopinsert")
      end },
      { "<leader>tk", function()
        vim.cmd("TestLast | stopinsert")
      end },
    },
  }
}
