---@diagnostic disable: missing-fields
return function (add)
  add({
    source="nvim-treesitter/nvim-treesitter",
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require("nvim-treesitter.configs").setup({
    auto_install = true,
    ensure_installed = { "vim", "vimdoc", "comment" },
    highlight = {
      enable = true,
      disable = function(_, buf)
        local max_filesize = 1000 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = false },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = '<c-s>',
        node_decremental = "<c-m>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding xor succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        include_surrounding_whitespace = false,
      },
    },
  })

  add("nvim-treesitter/nvim-treesitter-textobjects")
  add("nvim-treesitter/nvim-treesitter-context")
end
