local dap = require("dap")

local M = {
  last_testname = "",
  last_testpath = "",
  testtags = "test,account_test",
  buildtags = "test,account_test",
}

function M.setup()
  dap.adapters.go = {
    type = 'executable',
    command = 'node',
    args = {os.getenv('HOME') .. '/repoja/vscode-go/dist/debugAdapter.js'},
  }
  dap.configurations.go = {
    {
      type = 'go',
      name = 'Debug',
      buildFlags = "-tags " .. M.buildtags,
      request = 'launch',
      showLog = false,
      program = "${file}",
      dlvFlags = {"--check-go-version=false"},
      dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed

    },
    {
      type = 'go',
      name = 'Debug Test',
      buildFlags = "-tags " .. M.testtags,
      request = 'launch',
      mode = 'test',
      showLog = false,
      program = "./${relativeFileDirname}",
      dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
    },
  }
end


function M.set_testtags(testtags)
  M.testtags = testtags
  for _, v in pairs(dap.configurations.go) do
    if v.name == "Debug Test" then v.buildFlags = "-tags " .. M.testtags end
  end
end

function M.set_buildtags(buildtags)
  M.buildtags = buildtags
  local client = vim.lsp.get_active_clients({name = "gopls", bufnr = vim.api.nvim_get_current_buf()})
  if client[1] == nil then print("no gopls client attached to buffer") return end
  client[1].config.settings.gopls.buildFlags = {"-tags", M.buildtags}
  client[1].notify("workspace/didChangeConfiguration")
  client[1].notify("workspace/applyEdit")
  for _, v in pairs(dap.configurations.go) do
    if v.name == "Debug" then v.buildFlags = "-tags " .. M.buildtags end
  end
end

local tests_query = [[
(function_declaration
  name: (identifier) @testname
  parameters: (parameter_list
    . (parameter_declaration
      type: (pointer_type) @type) .)
  (#match? @type "*testing.(T|M)")
  (#match? @testname "^Test.+$")) @parent
]]

local subtests_query = [[
(call_expression
  function: (selector_expression
    operand: (identifier)
    field: (field_identifier) @run)
  arguments: (argument_list
    (interpreted_string_literal) @testname
    (func_literal))
  (#eq? @run "Run")) @parent
]]

local function debug_test(testname, testpath)
  dap.run({
    type = "go",
    name = testname,
    buildFlags = "-tags " .. M.testtags,
    request = "launch",
    mode = "test",
    program = testpath,
    args = { "-test.run", testname },
    dlvFlags = {"--check-go-version=false"},
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  })
end

local function get_closest_above_cursor(test_tree)
  local result
  for _, curr in pairs(test_tree) do
    if not result then
      result = curr
    else
      local node_row1, _, _, _ = curr.node:range()
      local result_row1, _, _, _ = result.node:range()
      if node_row1 > result_row1 then
        result = curr
      end
    end
  end
  if result == nil then
    return ""
  elseif result.parent then
    return string.format("%s/%s", result.parent, result.name)
  else
    return result.name
  end
end

local function is_parent(dest, source)
  if not (dest and source) then
    return false
  end
  if dest == source then
    return false
  end

  local current = source
  while current ~= nil do
    if current == dest then
      return true
    end

    current = current:parent()
  end

  return false
end

local function get_closest_test()
  local stop_row = vim.api.nvim_win_get_cursor(0)[1]
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  assert(ft == "go", "dap-go error: can only debug go files, not " .. ft)
  local parser = vim.treesitter.get_parser(0)
  local root = (parser:parse()[1]):root()

  local test_tree = {}

  local test_query = vim.treesitter.query.parse(ft, tests_query)
  assert(test_query, "dap-go error: could not parse test query")
  for _, match, _ in test_query:iter_matches(root, 0, 0, stop_row) do
    local test_match = {}
    for id, node in pairs(match) do
      local capture = test_query.captures[id]
      if capture == "testname" then
        local name = vim.treesitter.get_node_text(node, 0)
        test_match.name = name
      end
      if capture == "parent" then
        test_match.node = node
      end
    end
    table.insert(test_tree, test_match)
  end

  local subtest_query = vim.treesitter.query.parse(ft, subtests_query)
  assert(subtest_query, "dap-go error: could not parse test query")
  for _, match, _ in subtest_query:iter_matches(root, 0, 0, stop_row) do
    local test_match = {}
    for id, node in pairs(match) do
      local capture = subtest_query.captures[id]
      if capture == "testname" then
        local name = vim.treesitter.get_node_text(node, 0)
        test_match.name = string.gsub(string.gsub(name, " ", "_"), '"', "")
      end
      if capture == "parent" then
        test_match.node = node
      end
    end
    table.insert(test_tree, test_match)
  end

  table.sort(test_tree, function(a, b)
    return is_parent(a.node, b.node)
  end)

  for _, parent in ipairs(test_tree) do
    for _, child in ipairs(test_tree) do
      if is_parent(parent.node, child.node) then
        child.parent = parent.name
      end
    end
  end

  return get_closest_above_cursor(test_tree)
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

  if vim.fn.bufexists(term) > 0 then
    vim.api.nvim_buf_delete(term, { force = true })
  end

  vim.cmd("botright 24split new")

  local cmd = {"go", "test", "-v", "-tags", M.testtags, testpath, "-run", testname}

  vim.fn.termopen(cmd)
  term = vim.api.nvim_get_current_buf()

  vim.cmd("wincmd p")

  return true
end

vim.keymap.set("n", "<leader>ni", function() M.set_buildtags(vim.fn.input({default = M.buildtags})) end)
vim.keymap.set("n", "<leader>no", function() M.set_testtags(vim.fn.input({default = M.testtags})) end)
vim.keymap.set('n', '<leader>dd', M.debug_test)
vim.keymap.set('n', '<leader>df', M.debug_last_test)
vim.keymap.set('n', '<leader>tj', function() M.test("nearest") end)
vim.keymap.set('n', '<leader>tk', function() M.test("last") end)

return M
