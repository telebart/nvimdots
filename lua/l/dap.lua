local dap = require 'dap'
local dapui = require 'dapui'
local daptest = require("l.dap-test")

require('mason-nvim-dap').setup {
  automatic_setup = true,
  ensure_installed = {
    'delve'
  },
}

vim.keymap.set('n', '<leader>dh', dap.continue)
vim.keymap.set('n', '<leader>dj', dap.step_into)
vim.keymap.set('n', '<leader>dk', dap.step_over)
vim.keymap.set('n', '<leader>dl', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
vim.keymap.set('n', '<Up>', dap.continue)
vim.keymap.set('n', '<Left>', dap.step_into)
vim.keymap.set('n', '<Down>', dap.step_over)
vim.keymap.set('n', '<Right>', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dp', dapui.toggle)
vim.keymap.set('n', '<leader>do', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
    },
  },
  layouts = {
    {
      elements = {
        { id = "console", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "scopes", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
--dap.listeners.before.event_terminated['dapui_config'] = dapui.close
--dap.listeners.before.event_exited['dapui_config'] = dapui.close


-- https://stackoverflow.com/questions/43092364/debugging-go-tests-in-visual-studio-code

local buildtags = 'buildthis'
local testtags = 'test_remote test buildthis'

vim.keymap.set('n', '<leader>dd', function() daptest.debug_test(testtags) end)
vim.keymap.set('n', '<leader>df', function() daptest.debug_last_test(testtags) end)

dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = {os.getenv('HOME') .. '/repoja/vscode-go/dist/debugAdapter.js'};
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    buildTags = buildtags;
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  },
  {
    type = 'go';
    name = 'Debug Test';
    testTags = testtags;
    request = 'launch';
    mode = 'test';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  },
}

-- require('dap-go').setup()
require('nvim-dap-virtual-text').setup()

-- dap.adapters.delve = {
--   type = 'server',
--   port = '${port}',
--   executable = {
--     command = 'dlv',
--     args = {'dap', '--build-flags="-tags buildthis"', '-l', '127.0.0.1:${port}'},
--   }
-- }
--
-- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "delve",
--     name = "Debug",
--     request = "launch",
--     program = "${file}",
--   },
--   {
--     type = "delve",
--     name = "Debug test", -- configuration for debugging test files
--     request = "launch",
--     mode = "test",
--     program = "${file}"
--   },
--   -- works with go.mod packages and sub packages 
--   {
--     type = "delve",
--     name = "Debug test (go.mod)",
--     request = "launch",
--     mode = "test",
--     program = "./${relativeFileDirname}"
--   }
-- }


