return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    opts = {
      --- @usage 'auto'|'main'|'moon'|'dawn'
      variant = 'moon',
      --- @usage 'main'|'moon'|'dawn'
      dark_variant = 'main',
      bold_vert_split = false,
      dim_nc_background = false,
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,

      --- @usage string hex value or named color from rosepinetheme.com/palette
      groups = {
        background = 'base',
        background_nc = '_experimental_nc',
        panel = 'surface',
        panel_nc = 'base',
        border = 'highlight_med',
        comment = '#aaaaaa',
        link = 'iris',
        punctuation = 'subtle',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',

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
        FidgetTask = { fg = '#aaaaff', bg = 'none'},
        GitSignsAdd = { fg = 'teal', bg = 'none'},
        GitSignsChange = { fg = 'gold', bg = 'none'},
        GitSignsDelete = { fg = 'love', bg = 'none'},
        StatusLine = { fg = 'teal', bg = 'none'},
        NvimDapVirtualText = { fg = '#d484ff', bg = 'none'},
        DiffAdd = {bg='pine', blend=10},
        DiffChange = {bg='gold', blend=20},
        DiffText = {bg='gold', blend=50},
      }
    },
  },
}
