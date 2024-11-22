vim.o.autochdir = false
local root_names = { '.git', 'Makefile' }

function Root(lcd)
  local root = vim.fs.root(0, root_names)
  if lcd then vim.cmd("lcd") end
  if root == nil then return end
  vim.fn.chdir(root)
end

Root()
