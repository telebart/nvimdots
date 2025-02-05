local dap = require("dap")

local M = {
  last_testname = "",
  last_testpath = "",
  buildtags = "test,account_test",
}

local function get_closest_test()
  local current_node = vim.treesitter.get_node()
  local subtest = ""
  while current_node ~= nil do
    if current_node:type() == "function_declaration" then
      local name = current_node:field("name")[1]
      if name and vim.treesitter.get_node_text(current_node:field("name")[1], 0):sub(1, 4) == "Test" then
        return "^" .. vim.treesitter.get_node_text(name, 0) .. "$" .. subtest
      end
    end

    if current_node:type() == "call_expression" then
      local first_child = current_node:child(0)
      if first_child then
        local field = first_child:field("field")[1]
        if field and vim.treesitter.get_node_text(field, 0) == "Run" then
          subtest = "/^" .. vim.treesitter.get_node_text(current_node:child(1):child(1):child(1), 0) .. "$"
        end
      end
    end

    current_node = current_node:parent()
  end
  return ""
end

function M.setup()
  dap.adapters.go = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = {'dap', '-l', '127.0.0.1:${port}'},
    }
  }
  dap.configurations.go = {
    {
      type = 'go',
      name = 'Debug',
      buildFlags = "-tags=" .. M.buildtags,
      request = 'launch',
      showLog = false,
      program = "${file}",
      dlvFlags = {"--check-go-version=false"},
      dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed

    },
    {
      type = 'go',
      name = 'Debug package',
      buildFlags = "-tags=" .. M.buildtags,
      request = 'launch',
      showLog = false,
      program = "${fileDirname}",
      dlvFlags = {"--check-go-version=false"},
      dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed

    },
  }
end


function M.set_buildtags(buildtags)
  M.buildtags = buildtags
  for _, v in pairs(dap.configurations.go) do
    if v.name == "Debug Test" then v.buildFlags = "-tags=" .. buildtags end
  end
  local client = vim.lsp.get_clients({name = "gopls", bufnr = vim.api.nvim_get_current_buf()})[1]
  if client == nil then print("no gopls client attached to buffer") return end
  client.config.settings.gopls.buildFlags = {"-tags", M.buildtags}
  client.notify("workspace/didChangeConfiguration", {settings = client.config.settings})
  for _, v in pairs(dap.configurations.go) do
    if v.name == "Debug" then v.buildFlags = "-tags=" .. M.buildtags end
  end
end

local function debug_test(testname, testpath)
  dap.run({
    type = "go",
    name = testname,
    buildFlags = "-tags=" .. M.buildtags,
    request = "launch",
    mode = "test",
    program = testpath,
    args = { "-test.run", testname },
    dlvFlags = {"--check-go-version=false"},
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  })
end

function M.debug_test()
  local testname = get_closest_test()
  local relativeFileDirname = vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
  local testpath = string.format("./%s", relativeFileDirname)

  if testname == "" then
    vim.notify("no test found")
    return false
  end

  M.last_testname = testname
  M.last_testpath = testpath

  local msg = string.format("starting debug session '%s : %s'...", testpath, testname)
  vim.notify(msg)
  debug_test(testname, testpath)

  return true
end

function M.debug_last_test()
  local testname = M.last_testname
  local testpath = M.last_testpath

  if testname == "" then
    vim.notify("no last run test found")
    return false
  end

  local msg = string.format("starting debug session '%s : %s'...", testpath, testname)
  vim.notify(msg)
  debug_test(testname, testpath)
  return true
end

local term = nil

function M.test(scope)
  local testname = ""
  local testpath = ""
  if scope == "nearest" then
    testname = get_closest_test()
    local relativeFileDirname = vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
    testpath = string.format("./%s", relativeFileDirname)
    M.last_testpath = testpath
    M.last_testname = testname
  end
  if scope == "last" then
    testname = M.last_testname
    testpath = M.last_testpath
  end

  if testname == "" then
    vim.notify("no test found")
    return false
  end

  pcall(vim.api.nvim_buf_delete, term, { force = true })
  term = nil

  vim.cmd("botright 12split new")

  local cmd = {"gotestsum", "--format", "testname", "--", "-v", "-race", "-tags", M.buildtags, testpath, "-run", testname}
  vim.print(cmd)

  vim.fn.termopen(cmd)
  term = vim.api.nvim_get_current_buf()

  vim.cmd("wincmd p")
  vim.cmd.stopinsert()

  return true
end

vim.keymap.set("n", "<leader>ni", function()
  vim.ui.input({default = M.buildtags}, function(input)
    if input == nil then return end
    M.set_buildtags(string.gsub(input, " ", ","))
  end)
end)

vim.keymap.set('n', '<leader>dd', M.debug_test)
vim.keymap.set('n', '<leader>df', M.debug_last_test)

return M
