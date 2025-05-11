local add = MiniDeps.add
add("mfussenegger/nvim-dap")
add("theHamsta/nvim-dap-virtual-text")

require("nvim-dap-virtual-text").setup({
  virt_text_pos = "eol",
  display_callback = function(variable, buf, stackframe, node, options)
    return "▸" .. string.sub(variable.value, 1, 50)
  end,
})

local dap = require('dap')
local widgets = require("dap.ui.widgets")

vim.keymap.set('n', '<leader>dh', dap.continue)
vim.keymap.set('n', '<leader>dj', dap.step_into)
vim.keymap.set('n', '<leader>dk', dap.step_over)
vim.keymap.set('n', '<leader>dl', dap.step_out)
vim.keymap.set('n', '<leader>dc', dap.run_to_cursor)
vim.keymap.set('n', '<Left>', dap.continue)
vim.keymap.set('n', '<Right>', dap.step_into)
vim.keymap.set('n', '<Down>', dap.step_over)
vim.keymap.set('n', '<Up>', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)
vim.keymap.set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<leader>dw', function() widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<leader>da', widgets.hover )

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
