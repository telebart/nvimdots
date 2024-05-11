return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.files").setup({
        mappings = {
          go_in_plus = "l",
          go_in = "",
          go_out_plus = "h",
          go_out = "",
        },
        options = { use_as_default_explorer = false },
      })
      require("mini.notify").setup({
        window = {
          config = { border = "none", },
          winblend = 0,
        }
      })
      require("mini.surround").setup()
      require("mini.extra").setup()
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "gs"
        }
      })

      local win_config = function()
        local height = math.floor(0.618 * vim.o.lines)
        local width = math.floor(0.85 * vim.o.columns)
        return {
          anchor = 'NW', height = height, width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end

      require("mini.pick").setup({
        mappings = {
          choose_marked = "<C-q>",
        },
        window = {
          config = win_config,
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(args)
          local from = args.data.from
          local to = args.data.to
          if not from or not to then return end
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client.supports_method("workspace/willRenameFiles") then
              ---@diagnostic disable-next-line: invisible
              client.notify("workspace/didRenameFiles", {
                files = {
                  {
                    oldUri = vim.uri_from_fname(args.data.from),
                    newUri = vim.uri_from_fname(args.data.to),
                  },
                },
              })
            end
          end
        end,
      })

      -- FILES

      vim.keymap.set("n", "-", function()
        local path = vim.api.nvim_buf_get_name(0)

        if vim.fn.filereadable(path) == 0 then path = "" end
        MiniFiles.open(path)
        MiniFiles.reveal_cwd()
      end)

      -- PICKER

      local function file_exists(file)
        local f = io.open(file, "rb")
        if f then
          f:close()
        end
        return f ~= nil
      end

      local function lines_from(file)
        if not file_exists(file) then
          return {}
        end
        local lines = {}
        for line in io.lines(file) do
          lines[#lines + 1] = line
        end
        return lines
      end

      local config_path = vim.fn.stdpath("config")
      local file = config_path .. "/telerepos"
      local extra_repos = lines_from(file)

      local find_repo_cmd = { "fd", ".git$", "-HIp", "-d3", "-td", "--prune", "-x", "echo", "{//}", ";" }
      local home = os.getenv("HOME")
      local repos = { "/.config/nvim", "/repos" }
      for _, v in ipairs(repos) do
        table.insert(find_repo_cmd, home .. v)
      end
      for _, v in ipairs(extra_repos) do
        table.insert(find_repo_cmd, home .. v)
      end

      local function wrap(builtin, local_opts, opts)
        MiniFiles.close()
        return MiniPick.builtin[builtin](local_opts, opts)
      end

      vim.keymap.set("n", "<C-p>", function()
        vim.o.smartcase, vim.o.ignorecase = true, true
        wrap("files")
        vim.o.smartcase, vim.o.ignorecase = false, false
      end)
      vim.keymap.set("n", "<leader>pa", function() wrap("grep_live") end)
      vim.keymap.set("n", "<leader>pw", function() wrap("grep", { pattern = vim.fn.expand("<cword>") }) end)
      vim.keymap.set("n", "<leader>pb", function() wrap("buffers") end)
      vim.keymap.set("n", "<leader>ph", function() wrap("help") end)
      vim.keymap.set("n", "<leader>fj", function()
        local selection = wrap("cli", { command = find_repo_cmd })
        if selection == nil then return end
        vim.defer_fn(function()
          wrap("files", nil, { source = { cwd = selection } })
        end, 0)
      end)

      local function git_branches()
        MiniExtra.pickers.git_branches({}, {
          source = {
            cwd = ".",
            name = "Git Branches",
            choose = function(item)
              local out = {}
              for w in item:gmatch("%S+") do
                table.insert(out, w)
              end
              vim.fn.jobstart({ "git", "checkout", out[2] })
            end,
          },
        })
      end

      vim.keymap.set("n", "<leader>OP", function()
        vim.cmd("silent !git fetch -p")
        git_branches()
      end)
      vim.keymap.set("n", "<leader>op", function()
        git_branches()
      end)
    end,
  },
}
