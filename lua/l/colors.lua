local toggle = false

vim.cmd[[
hi Keyword guifg=#3e8fb0
hi @variable.member guifg=NvimLightBlue
hi BlinkCmpKind guifg=NvimLightCyan
hi link BlinkCmpLabelDeprecated DiagnosticDeprecated
hi PmenuSel cterm=underline guibg=NvimDarkGray4
hi Operator guifg=NvimLightGrey4
hi Delimiter guifg=NvimLightGrey4
hi StatusLine guibg=NvimDarkGrey3
hi StatusLineNC guibg=NvimDarkGrey2
]]

return function()
  if toggle then
    vim.cmd[[
    hi Normal guibg=NvimDarkGrey2
    hi NormalFloat guibg=NvimDarkGrey1
    hi PMenu guibg=NvimDarkGrey3
    ]]
  else
    vim.cmd[[
    hi Normal guibg=NONE
    hi NormalFloat guibg=NONE
    hi PMenu guibg=NONE
    ]]
  end
  toggle = not toggle
end
