---@diagnostic disable: missing-fields
local add = MiniDeps.add

add({
  source="nvim-treesitter/nvim-treesitter",
  checkout = "main",
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'*'},
  callback = function(args)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
    local parser_name = vim.treesitter.language.get_lang(ft)
    if not require("nvim-treesitter.parsers")[parser_name] then return end
    require('nvim-treesitter').install(parser_name)
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

add("nvim-treesitter/nvim-treesitter-context")
