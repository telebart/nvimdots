require'fidget'.setup({
  window = {
    relative = "win",         -- where to anchor, either "win" or "editor"
    blend = 0,              -- &winblend for the window
    zindex = nil,             -- the zindex value for the window
    border = "single",          -- style of border for the fidget window
},
})

--vim.cmd[[highlight FidgetTitle guifg=#aaaaff guibg=None]]
vim.cmd[[highlight FidgetTask guifg=#aaaaff guibg=None]]
