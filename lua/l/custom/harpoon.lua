return function (add)
  add({
    source="theprimeagen/harpoon",
    checkout="harpoon2"
  })
  add("nvim-lua/plenary.nvim")
  local harpoon = require("harpoon")
  vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  for i=1,9 do
    vim.keymap.set("n", "<leader>"..i, function()
      MiniFiles.close()
      harpoon:list():select(i)
    end)
  end

  harpoon.setup({
    settings = {
      save_on_toggle = true,
    }
  })
end
