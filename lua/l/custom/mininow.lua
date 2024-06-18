return function (add)
  add("echasnovski/mini.nvim")
  require("mini.files").setup({
    mappings = {
      go_in_plus = "l",
      go_in = "",
      go_out_plus = "h",
      go_out = "",
    },
    options = { use_as_default_explorer = false },
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
    pattern = "MiniPickStart",
    callback = MiniFiles.close,
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

  vim.keymap.set("n", "<C-p>", function()
    vim.o.smartcase, vim.o.ignorecase = true, true
    MiniPick.builtin.files()
    vim.o.smartcase, vim.o.ignorecase = false, false
  end)
  vim.keymap.set("n", "<leader>pa", MiniPick.builtin.grep_live)
  vim.keymap.set("n", "<leader>pw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end)
  vim.keymap.set("n", "<leader>pb", MiniPick.builtin.buffers)
  vim.keymap.set("n", "<leader>ph", MiniPick.builtin.help)
  vim.keymap.set("n", "<leader>fj", function()
    local selection = MiniPick.builtin.cli({ command = find_repo_cmd },
      { source = { choose = function() return nil end }})
    if selection == nil then return end
    MiniPick.builtin.files(nil, { source = { cwd = selection } })
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
end
