vim.o.autochdir = false
local root_cache = {}
local root_names = { '.git', 'Makefile' }

function Find_root(names)
  if names == nil then names = root_names end
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end
  path = vim.fs.dirname(path)

  -- Try using cache
  local res = root_cache[path]
  if res ~= nil then return res end

  -- Find root
  local root_file = vim.fs.find(names, { path = path, upward = true })[1]
  if root_file == nil then return end

  -- Use absolute path and cache result
  res = vim.fn.fnamemodify(vim.fs.dirname(root_file), ':p')
  root_cache[path] = res

  return res
end

function Root()
  local root = Find_root()
  if root == nil then return end
  vim.fn.chdir(root)
end

Root()
