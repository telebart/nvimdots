return {
  "rebelot/heirline.nvim",
  config = function ()
    vim.defer_fn(function ()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local Align = { provider = "%=" }
      local Space = { provider = " " }

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      -- We can now define some children separately and add them later

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return "[No Name]" end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = utils.get_highlight("Type").fg },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "⍉",
          hl = { fg = utils.get_highlight("Error").fg },
        },
      }

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = utils.get_highlight("Type").fg, bold = true, force=true }
          end
          -- unchanged filepath name
          return { fg = utils.get_highlight("Keyword").fg, bold = true, force=true }
        end,
      }

      FileNameBlock = utils.insert(FileNameBlock,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
      )

      local FileType = {
        provider = function()
          return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local FileEncoding = {
        provider = function()
          return vim.bo.fenc:upper()
        end,
        hl = { fg = utils.get_highlight("Function").fg },
      }

      local FileSize = {
        provider = function()
          local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
          local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
          fsize = (fsize < 0 and 0) or fsize
          if fsize < 1024 then
            return fsize..suffix[1]
          end
          local i = math.floor((math.log(fsize) / math.log(1024)))
          return string.format("%.2g%s", fsize / (1024^i), suffix[i + 1])
        end,
        hl = { fg = utils.get_highlight("Function").fg },
      }

      local Ruler = {
        provider = "%(%l/%L%):%c/%-2{virtcol('$') - 1}",
        hl = { fg = utils.get_highlight("Function").fg },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = {'LspAttach', 'LspDetach'},
        provider  = function()
          local names = {}
          for _, server in pairs(vim.lsp.get_active_clients(nil)) do
            table.insert(names, server.name)
          end
          return "[" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local statusline = {
        FileNameBlock,
        Space,
        FileSize,
        Align,
        Align,
        FileType,
        Space,
        LSPActive,
        Space,
        FileEncoding,
        Space,
        Ruler,
      }

      require('heirline').setup({statusline = statusline})
    end, 1)
  end
}
