local add = MiniDeps.add
add("nvim-mini/mini.nvim")
require("mini.icons").setup({})
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
  callback = function ()
    vim.o.smartcase, vim.o.ignorecase = true, true
  end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStop",
  callback = function ()
    vim.o.smartcase, vim.o.ignorecase = false, false
  end
})

vim.keymap.set("n", "-", function()
  local path = vim.api.nvim_buf_get_name(0)

  if vim.fn.filereadable(path) == 0 then path = "" end
  MiniFiles.open(path)
  MiniFiles.reveal_cwd()
end)

local home = os.getenv("HOME")
local find_repo_cmd = { "fd", ".git$", "-Hp", "-d10", "-td", "--prune", "-x", "echo", "{//}", ";",
  home.."/.config/nvim",
  home.."/repos" ,
  home.."/go/src" ,
}

vim.keymap.set("n", "<C-p>", MiniPick.builtin.files)
vim.keymap.set("n", "<leader>pa", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<leader>pw", function() MiniPick.builtin.grep({ pattern = "\\<"..vim.fn.expand("<cword>").."\\>" }) end)
vim.keymap.set("n", "<leader>pr", MiniPick.builtin.resume)
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
        vim.system({ "git", "checkout", out[2] }, {timeout = 3000}, function (obj)
          if obj.code == 0 then
            vim.print(string.format("checkout %s", out[2]))
          else
            vim.print("checkout failed")
          end
        end)
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

require("mini.completion").setup({
  delay = { signature = 10000000 },
  fallback_action =function()end,
  mappings = {
    force_twostep = "",
    force_fallback = "",
  },
})
vim.keymap.set("i", "<C-e>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e>"
  else
    return "<C-x><C-u>"
  end
end, { expr = true })
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    local selected = vim.fn.complete_info().selected
    if selected == -1 then
      return "<C-n><C-y>"
    end
    return "<C-y>"
  else
    return "<Tab>"
  end
end, { expr = true })
