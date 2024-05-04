vim.keymap.set('n', '<leader>tj', function() require("l.dap-test").test("nearest") end,{buffer=0})
vim.keymap.set('n', '<leader>tk', function() require("l.dap-test").test("last") end,{buffer=0})
