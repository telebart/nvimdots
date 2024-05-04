vim.o.autochdir = false
local root_names = { '.git', 'Makefile' }

function Root()
  local root = vim.fs.root(0, root_names)
  if root == nil then return end
  vim.fn.chdir(root)
end

Root()
