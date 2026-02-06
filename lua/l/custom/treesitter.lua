---@diagnostic disable: missing-fields
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'*'},
  callback = function(args)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
    local parser_name = vim.treesitter.language.get_lang(ft)
    if not require("nvim-treesitter.parsers")[parser_name] then return end
    require('nvim-treesitter').install(parser_name)
    vim.treesitter.start()
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
