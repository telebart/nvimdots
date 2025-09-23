local function load()
  pcall(vim.cmd, "argd *")
  local args_dir = ".vim"
  if not vim.loop.fs_stat(".git") then return end
  if not vim.loop.fs_stat(args_dir) then return end

  local cat_out = vim.fn.system({"cat", args_dir.."/args"})
  if cat_out.stderr then return end
  if #cat_out then
    local args = cat_out:gsub("\n", " ")
    vim.cmd("arga "..args)
  end
end
vim.schedule(load, 0)

vim.api.nvim_create_autocmd("DirChanged", {
  callback = load
})

local function save()
  if not vim.loop.fs_stat(vim.fn.getcwd().."/.git") then return end
  local lines = ""
  for _, arg in ipairs(vim.fn.argv()) do
    lines = lines .. arg .. "\n"
  end
  vim.fn.mkdir(".vim", "p")
  local f = io.open(".vim/args", "w")
  if f then
    f:write(lines)
    f:close()
  end
end

local function create_win()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
  }
  local win = vim.api.nvim_open_win(buf, true, opts)

  local lines = {}
  for _, arg in ipairs(vim.fn.argv()) do
    table.insert(lines, arg)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = ""..win,
    callback = function()
      local new_args = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      pcall(vim.cmd, "argd *")
      if #new_args then
        for _, arg in ipairs(new_args) do
          vim.cmd("%arga "..arg)
        end
      end
      save()
    end,
  })
  vim.keymap.set("n", "q", ":bd<cr>", { buffer = buf, silent=true })
end

vim.keymap.set("n", "<C-n>", create_win)
vim.keymap.set("n", "<leader>a", function()
  vim.cmd("%arga % | argdedup")
  save()
end)
for i=1,9 do
  vim.keymap.set("n", "<leader>"..i, function()
    pcall(vim.cmd, i.."argu")
  end)
end

