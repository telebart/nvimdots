local dir = ".vim"
local file = dir.."/args"
local state = {}

local function load()
  if not vim.loop.fs_stat(".git") then return end
  local f = io.open(file, "r")
  if not f then return end
  local content = f:read("a")
  state = vim.split(content, "\n", {trimempty=true})
end
load()

vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("HarpoonArgs", {clear=true}),
  callback = load
})

local function save()
  if not vim.loop.fs_stat(vim.fn.getcwd().."/.git") then return end
  vim.fn.mkdir(dir, "p")
  local f = io.open(file, "w")
  if f then
    f:write(vim.fn.join(state, "\n"))
    f:close()
  end
end

local function create_win()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, state)

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    callback = function()
      state = vim.iter(vim.api.nvim_buf_get_lines(buf, 0, -1, false)):filter(function(x) return x ~= "" end):totable()
      save()
    end,
  })
  vim.keymap.set("n", "q", ":bd<cr>", { buffer = buf, silent=true })
  vim.keymap.set("n", "<ESC>", ":bd<cr>", { buffer = buf, silent=true })
end

vim.keymap.set("n", "<C-n>", create_win)
vim.keymap.set("n", "<leader>a", function()
  local path = vim.fn.expand("%")
  if vim.list_contains(state, path) then return end
  table.insert(state, path)
  save()
end)
for i=1,9 do
  vim.keymap.set("n", "<leader>"..i, function()
    local path = state[i]
    if path then vim.cmd("e " .. path) end
  end)
end

