-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
now(function () require("l.custom.colorschema")(add) end)
now(function () require("l.custom.heirline")(add) end)
now(function () require("l.custom.lsp")(add) end)
now(function () require("l.custom.mininow")(add) end)
later(function () require("l.custom.treesitter")(add) end)
later(function () require("l.custom.minilater") end)
later(function () require("l.custom.harpoon")(add) end)
later(function () require("l.custom.coding")(add) end)
later(function () require("l.custom.dap")(add) end)
later(function () require("l.custom.gitsigns")(add) end)
later(function () require("l.custom.others")(add, later) end)
