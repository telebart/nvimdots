return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              'class',
              'function',
              'method',
              -- 'for', -- These won't appear in the context
              -- 'while',
              -- 'if',
              -- 'switch',
              -- 'case',
            },
            -- Example for a specific filetype.
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            --   rust = {
            --       'impl_item',
            --   },
          },
          exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
          },

          -- [!] The options below are exposed but shouldn't require your attention,
          --     you can safely ignore them.

          zindex = 20, -- The Z-index of the context window
          mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
          separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
        }
      },
    },
    cmd = { "TSUpdateSync" },
    opts = {
      auto_install = true
      ,additional_vim_regex_highlighting = false
      ,ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "typescript", "vim", "comment"}
      ,disable = function(_, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end
      ,highlight = { enable = true }
      ,indent = { enable = true }
      ,incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          -- scope_incremental = '<c-s>',
          node_decremental = '<c-m>',
        },
      }
      ,textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding xor succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          include_surrounding_whitespace = false,
        },
      },
    },
  },
}
