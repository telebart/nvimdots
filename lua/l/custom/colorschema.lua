return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    opts = {
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
      }
    },
  },
}
