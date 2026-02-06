---@diagnostic disable: missing-fields
require('nvim-treesitter').install({
  "comment",
  "diff",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "jsdoc",
  "luadoc",
  "markdown",
  "markdown_inline",
  "printf",
  "query",
  "regex",
  "vim",
  "vimdoc",
})

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
