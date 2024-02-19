return {
  -- { "folke/neodev.nvim", opts = {} },
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
    "j-hui/fidget.nvim",
    opts = { notification = { window = {winblend = 0} }}
  },
}
