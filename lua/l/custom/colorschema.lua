return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    opts = {
      variant = 'moon',
      dark_variant = 'main',
      dim_nc_background = false,
      styles = {
        bold = true,
        italic = false,
        transparency = true,
      },
      --- @usage string hex value or named color from rosepinetheme.com/palette
      groups = {
        panel = 'surface',
        border = 'muted',
        -- border = 'highlight_med',
        -- comment = '#aaaaaa',
        link = 'iris',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',

        git_add = "pine",
        git_change = "gold",
        git_delete = "love",

        headings = {
          h1 = 'iris',
          h2 = 'foam',
          h3 = 'rose',
          h4 = 'gold',
          h5 = 'pine',
          h6 = 'foam',
        }
        -- or set all headings at once
        -- headings = 'subtle'
      },

      -- ERROR TODO NOTE WARNING
      -- Change specific vim highlight groups
      -- https://github.com/rose-pine/neovim/wiki/Recipes
      highlight_groups = {
        Directory = { fg = 'pine', bg = 'none'},
        StatusLine = { fg = 'pine', bg = 'none'},
        NvimDapVirtualText = { fg = '#d484ff', bg = 'none'},
        DiffAdd = {bg='pine', blend=10},
        DiffChange = {bg='gold', blend=20},
        DiffText = {bg='gold', blend=50},
        Search = {bg='#aaaaaa'},
      }
    },
  },
}
