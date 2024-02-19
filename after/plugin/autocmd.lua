vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup("l_yank_highlight", { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.cmd([[
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("l_auto_format", { clear = true }),
  pattern = {"*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.graphql", "*.tf"},
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

local function run_term(prog)
  if prog == "lf" then
    vim.env.LFCD = nil
    local path = vim.api.nvim_buf_get_name(0)
    prog = prog .. " " .. path
  end
  vim.cmd("tabnew")
  vim.cmd("term " .. prog)
  local buf_num = vim.api.nvim_get_current_buf()
  vim.opt_local.spell = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.showtabline = 0
  vim.api.nvim_input("i")
  vim.api.nvim_create_autocmd("TermClose", {
    group = vim.api.nvim_create_augroup("l_term_close", { clear = true }),
    once = true,
    buffer = buf_num,
    callback = function()
      vim.cmd("bd")
    end,
  })
end

vim.keymap.set('n', '<leader>lg', function() run_term("lazygit") end)
vim.keymap.set('n', '<leader>ld', function() run_term("lazydocker") end)
vim.keymap.set('n', '<leader>lf', function() run_term("lf") end)
