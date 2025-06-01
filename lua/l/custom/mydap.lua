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
local frames_sb = widgets.sidebar(widgets.frames)
local threads_sb = widgets.sidebar(widgets.threads)
local expression_sb = widgets.sidebar(widgets.expression)
local sidebars = {
  {
    name = "Frames",
    widget = frames_sb,
  },
  {
    name = "Threads",
    widget = threads_sb,
  },
}

vim.keymap.set("n", "<leader>dg", function() MiniPick.ui_select(sidebars, {
  prompt = "Select sidebar to open",
  format_item = function(item)
    return item.name
  end,
}, function(sidebar)
    for _, sb in ipairs(sidebars) do
      if sb.widget.open then
        sb.widget.close()
      end
    end
  if sidebar then
    sidebar.widget.open()
  end
end) end)

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
vim.keymap.set('n', '<leader>dw', function() frames_sb.toggle() end)
vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end)
vim.keymap.set('n', '<leader>da', widgets.hover )
vim.keymap.set('n', '<leader>dp', function () widgets.preview(nil, { listener = { "event_stopped" }}) end)

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
