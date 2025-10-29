-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('vim._extui').enable({enable = true})

require('mini.deps').setup({ path = { package = path_package } })

local now, later = MiniDeps.now, MiniDeps.later
now(function () require("l.custom.lsp") end)
now(function () require("l.custom.mininow") end)
now(function () require("l.custom.treesitter") end)
later(function () require("l.custom.coding") end)
later(function () require("l.custom.minilater") end)
later(function () require("l.custom.mydap") end)
later(function () require("l.custom.gitsigns") end)
later(function () require("l.custom.others") end)

