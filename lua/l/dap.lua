local dap = require 'dap'
local dapui = require 'dapui'

vim.keymap.set('n', '<leader>dh', dap.continue)
vim.keymap.set('n', '<leader>dj', dap.step_into)
vim.keymap.set('n', '<leader>dk', dap.step_over)
vim.keymap.set('n', '<leader>dl', dap.step_out)
vim.keymap.set('n', '<leader>d<space>', dap.run_to_cursor)
vim.keymap.set('n', '<Up>', dap.continue)
vim.keymap.set('n', '<Left>', dap.step_into)
vim.keymap.set('n', '<Down>', dap.step_over)
vim.keymap.set('n', '<Right>', dap.step_out)
vim.keymap.set('n', '<leader>dp', dapui.toggle)
vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      disconnect = "",
      pause = "",
      play = "",
      run_last = "",
      step_back = "",
      step_into = "",
      step_out = "",
      step_over = "",
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
      size = 0.2,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "scopes", size = 0.5 },
      },
      size = 0.30,
      position = "bottom",
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({reset = true}) end
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('nvim-dap-virtual-text').setup({})
require("l.dap-test").setup()
