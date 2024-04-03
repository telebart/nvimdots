return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local harpoon = require("harpoon")
    local keys = {
      { "<leader>a", function() harpoon:list():add() end },
      { "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end },
    }
    for  i=1,9 do
      table.insert(keys, { "<leader>"..i, function() harpoon:list():select(i) end })
    end
    return keys
  end,
  opts = {
    settings = {
      save_on_toggle = true,
    }
  }
}
