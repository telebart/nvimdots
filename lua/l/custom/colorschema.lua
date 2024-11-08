return function (add)
  add({
    source = "rose-pine/neovim",
    name = "rose-pine",
  })
  require("rose-pine").setup({
    variant = 'moon',
    dim_nc_background = false,
    styles = {
      italic = false,
      transparency = true,
    },
    -- ERROR TODO NOTE WARNING
    -- Change specific vim highlight groups
    -- https://github.com/rose-pine/neovim/wiki/Recipes
    highlight_groups = {
      DiffText = {blend=40},
      MiniPickMatchRanges = {fg="rose"},
      MiniNotifyNormal = {fg="rose"},
    }
  })

  vim.cmd[[
      colorscheme rose-pine
      hi WinBar guibg=NONE
      hi WinBarNC guibg=NONE
      hi StatusLineTerm guibg=NONE
      hi StatusLineTermNC guibg=NONE
      ]]
end
