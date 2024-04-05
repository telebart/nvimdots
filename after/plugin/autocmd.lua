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
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
]])

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("l_auto_format", { clear = true }),
  pattern = {"*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.graphql", "*.tf"},
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "term://*",
  command = "setlocal nonu nornu nospell signcolumn=no | startinsert"
})

local function run_term(prog, split)
  vim.api.nvim_create_autocmd("TermClose", {
    group = vim.api.nvim_create_augroup("l_term_close", { clear = true }),
    once = true,
    callback = function()
      vim.api.nvim_buf_delete(0, {})
    end,
  })
  local style = "tabnew"
  if split then
    style = string.format("%dsplit",vim.fn.winheight(0)/3+1)
  end

  if not prog then
    vim.cmd(style .." term://fish")
    return
  end
  if prog == "lf" then
    local path = vim.api.nvim_buf_get_name(0)
    prog = prog .. " " .. path
  end
  vim.cmd(string.format(style .. " term://%s",prog))
end

vim.api.nvim_create_user_command("Term", function (args)
  print(args.args)
  run_term(args.args)
end, {nargs = '?'})

vim.api.nvim_create_user_command("Terms", function (args)
  run_term(args.args, true)
end, {nargs = '?'})

vim.keymap.set('n', '<leader>lg', function() run_term("lazygit") end)
vim.keymap.set('n', '<leader>ld', function() run_term("lazydocker") end)
vim.keymap.set('n', '<leader>lf', function() run_term("lf") end)
vim.keymap.set('n', '<leader>to', function() run_term(nil, true) end)
