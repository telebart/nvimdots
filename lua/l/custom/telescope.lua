local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- tests the functions above
local config_path = vim.fn.stdpath("config")
local file = config_path .. '/telerepos'
local extra_repos = lines_from(file)

local find_repo_cmd = {"fd", ".git$", "-Hp", "-d3", "-td", "--prune", "-x", "echo", "{//}", ';'}
local home = os.getenv("HOME")
local repos = {"/.config/nvim", "/repos"}
for _,v in ipairs(repos) do
  table.insert(find_repo_cmd, home..v)
end
for _,v in ipairs(extra_repos) do
  table.insert(find_repo_cmd, home..v)
end

vim.keymap.set("n", "<leader>ps", "<cmd>lua MiniPick.builtin.grep({ pattern = vim.fn.input(\"Grep For > \")})<CR>")
vim.keymap.set("n", "<C-p>", function ()
  vim.o.smartcase = true
  vim.o.ignorecase = true
  require("mini.pick").builtin.files()
  vim.o.smartcase = false
  vim.o.ignorecase = false
end)
vim.keymap.set("n", "<leader>pa", "<cmd>Pick grep_live<CR>")
vim.keymap.set("n", "<leader>pw", "<cmd>Pick grep pattern='<cword>'<CR>")
vim.keymap.set("n", "<leader>pb", "<cmd>Pick buffers<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<CR>")
vim.keymap.set("n", "<leader>fj", function()
  local selection = require("mini.pick").builtin.cli({command=find_repo_cmd})
  if selection == nil then return end
  require("mini.pick").builtin.files(nil,{source = {cwd=selection}})
end)


vim.keymap.set("n", "<leader>op", function ()
  require("mini.extra").pickers.git_branches({}, {
    source = {
      cwd = ".",
      name = "Git Branches",
      choose = function(item)
        local out = {}
        for w in item:gmatch("%S+") do table.insert(out, w) end
        vim.fn.jobstart({ "git", "checkout", out[2] })
      end,
    }
  })
end)

return {
  {
    'echasnovski/mini.pick',
    version = false,
    opts = {
      mappings = {
        choose_marked = '<C-q>',
      }
    },
    dependencies = {
      'echasnovski/mini.extra',
      version = false,
      config = function()
        require('mini.extra').setup()
      end
    }
  }
}
