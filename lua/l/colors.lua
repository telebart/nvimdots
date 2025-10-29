local toggle = true

vim.api.nvim_set_hl(0, "Keyword", { fg = "#3e8fb0", bold = true })
vim.api.nvim_set_hl(0, "@variable.member", { fg = "NvimLightBlue" })
vim.api.nvim_set_hl(0, "Operator", { fg = "NvimLightGrey4" })
vim.api.nvim_set_hl(0, "Delimiter", { fg = "NvimLightGrey4" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NvimDarkGrey3" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NvimDarkGrey2" })

vim.api.nvim_set_hl(0, "@markup.heading.delimiter.markdown", { fg = "#4fc3e8", bold = true })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "#4fc3e8" })
vim.api.nvim_set_hl(0, "@markup.quote.markdown", { fg = "NvimLightBlue", italic = true })
vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = "NvimLightGreen" })
vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { fg = "NvimLightCyan", underline = true })
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#4fc3e8", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "NvimLightBlue", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "NvimLightCyan", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "NvimLightGreen", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "NvimLightYellow", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "NvimLightMagenta", bold = true })
vim.api.nvim_set_hl(0, "@markup.rule.markdown", { fg = "#4fc3e8" })
vim.api.nvim_set_hl(0, "@markup.raw.delimiter.markdown_inline", { fg = "NvimLightYellow" })
vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { fg = "#4fc3e8", underline = true })
vim.api.nvim_set_hl(0, "@markup.link.delimiter.markdown_inline", { fg = "NvimLightGrey4" })
vim.api.nvim_set_hl(0, "@markup.link.title.markdown_inline", { fg = "NvimLightGreen", underline = true })
vim.api.nvim_set_hl(0, "@markup.link.label.markdown", { fg = "NvimLightBlue" })
vim.api.nvim_set_hl(0, "@markup.link.reference.markdown", { fg = "#4fc3e8" })
vim.api.nvim_set_hl(0, "@markup.link.delimiter.markdown", { fg = "NvimLightGrey4" })
vim.api.nvim_set_hl(0, "@markup.footnote.label.markdown", { fg = "NvimLightCyan" })
vim.api.nvim_set_hl(0, "@markup.footnote.definition.markdown", { fg = "NvimLightCyan" })
vim.api.nvim_set_hl(0, "@escape.markdown", { fg = "#4fc3e8" })
vim.api.nvim_set_hl(0, "@error.markdown", { fg = "NvimLightRed", underline = true })

local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu" })

return function()
  if toggle then
    vim.api.nvim_set_hl(0, "Normal", normal)
    vim.api.nvim_set_hl(0, "NormalFloat", normal_float)
    vim.api.nvim_set_hl(0, "Pmenu", pmenu)
    os.execute("toggle_opacity.sh")
  else
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
    os.execute("toggle_opacity.sh")
  end
  toggle = not toggle
end
