local dap = require('dap')
local widgets = require("dap.ui.widgets")
local frames_sb = widgets.sidebar(widgets.frames)
local threads_sb = widgets.sidebar(widgets.threads)
local expression_sb = widgets.sidebar(widgets.expression)
local sidebars = {
  { name = "Frames", widget = frames_sb, },
  { name = "Threads", widget = threads_sb, },
  { name = "Expressions", widget = expression_sb, },
}

-- require("dap-disasm").setup({})
require("dap-view").setup({
  virtual_text = {
    enabled = true,
    position = "eol",
    format = function(variable, _, _)
      local value = variable.value
      local type_str = variable.type
      if type_str and value:sub(1, #type_str) == type_str then
        value = vim.trim(value:sub(#type_str + 1))
      end
      local max_len = 50
      if #value > max_len then
        value = value:sub(1, max_len) .. "…"
      end
      return "▸" .. value
    end,
    prefix = function() return "" end,
  },
  winbar = {
    sections = {
      -- "disassembly",
      "watches",
      "scopes",
      "exceptions",
      "breakpoints",
      "threads",
      "repl"
    },
    controls = {
      enabled = true,
    }
  }
})


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
vim.keymap.set({"i",'n'}, '<Left>', dap.continue)
vim.keymap.set({"i",'n'}, '<Right>', dap.step_into)
vim.keymap.set({"i",'n'}, '<Down>', dap.step_over)
vim.keymap.set({"i",'n'}, '<Up>', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)
vim.keymap.set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<leader>dw', function() frames_sb.toggle() end)
vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end)
vim.keymap.set('n', '<leader>da', widgets.hover )
vim.keymap.set('n', '<leader>dp', "<cmd>DapViewToggle<CR>")
vim.keymap.set('n', '<leader>dP', "<cmd>DapViewWatch<CR>")

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
