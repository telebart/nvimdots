-- return {
--   {
--     "theprimeagen/harpoon",
--     config = function()
--       local mark = require("harpoon.mark")
--       local ui = require("harpoon.ui")
--
--       vim.keymap.set("n", "<leader>a", mark.add_file)
--       vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
--
--       for  i=1,9 do
--         vim.keymap.set("n", "<leader>"..i, function() ui.nav_file(i) end)
--       end
--
--       require("harpoon").setup({
--         menu = {
--           width = 90,
--         }
--       })
--     end
--   }
-- }

return {
  {
    'MeanderingProgrammer/harpoon-core.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local mark = require("harpoon-core.mark")
      local ui = require("harpoon-core.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

      for  i=1,9 do
        vim.keymap.set("n", "<leader>"..i, function() ui.nav_file(i) end)
      end

      require('harpoon-core').setup({
        -- Make existing window active rather than creating a new window
        use_existing = true,
        -- Set marks specific to each git branch inside git repository
        mark_branch = false,
        -- Use the previous cursor position of marked files when opened
        use_cursor = true,
        -- Settings for popup window
        menu = {
          width = 90,
        },
      })
    end,
  }
}
