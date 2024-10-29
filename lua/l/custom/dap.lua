---@diagnostic disable: missing-fields, undefined-field
return function(add)
  add("mfussenegger/nvim-dap")
  add("rcarriga/nvim-dap-ui")
  add("nvim-neotest/nvim-nio")

  require("dapui").setup({
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
          { id = "watches", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.17 },
          { id = "console", size = 0.33 },
        },
        size = 0.2,
        position = "right",
      },
      {
        elements = {
          { id = "scopes", size = 0.5 },
          { id = "repl", size = 0.5 },
        },
        size = 0.30,
        position = "bottom",
      },
    },
  })


  add("theHamsta/nvim-dap-virtual-text")
  require("nvim-dap-virtual-text").setup({
    virt_text_pos = "eol",
    display_callback = function(variable, buf, stackframe, node, options)
      return "▸" .. string.sub(variable.value, 1, 50)
    end,
  })

  local dap = require('dap')
  local dapui = require('dapui')

  vim.keymap.set('n', '<leader>dh', dap.continue)
  vim.keymap.set('n', '<leader>dj', dap.step_into)
  vim.keymap.set('n', '<leader>dk', dap.step_over)
  vim.keymap.set('n', '<leader>dl', dap.step_out)
  vim.keymap.set('n', '<leader>d<space>', function () dap.run_to_cursor() end)
  vim.keymap.set('n', '<Left>', dap.continue)
  vim.keymap.set('n', '<Right>', dap.step_into)
  vim.keymap.set('n', '<Down>', dap.step_over)
  vim.keymap.set('n', '<Up>', dap.step_out)
  vim.keymap.set('n', '<leader>dp', dapui.toggle)
  vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
  vim.keymap.set('n', '<leader>do', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)
  vim.keymap.set('n', '<leader>?', function() dapui.eval(nil, { enter = true }) end)

  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({reset = true}) end
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  require("l.dap-test").setup()

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = 8123,
    executable = {
      command = 'js-debug-adapter',
      args = { "8123" },
    },
  }

  for _, language in ipairs({"javascript", "typescript"}) do
    dap.configurations[language] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }
  end

end
