vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup("l_yank_highlight", { clear = true }),
  pattern = '*',
  callback = function()
    vim.hl.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.cmd([[
  au FileType * setlocal formatoptions-=ro
  " start from last position
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  " create directory before writing file
  au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
  au TermOpen * setlocal nonu nornu nospell signcolumn=no so=0 siso=0 | startinsert | nnoremap <buffer> q <CMD>bd!<CR>
]])

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("l_auto_format", { clear = true }),
  pattern = {"*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.graphql", "*.tf"},
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

local function run_term(prog, style)
  vim.api.nvim_create_autocmd("TermClose", {
    group = vim.api.nvim_create_augroup("l_term_close", { clear = true }),
    once = true,
    callback = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  style = style or "tabnew"

  if not prog then
    vim.cmd(style .." term://fish")
    return
  end
  prog = prog:gsub('%%', vim.fn.expand("%"))
  vim.cmd(string.format(style .. " term://%s",prog))
end

vim.keymap.set('n', '<leader>lg', function() run_term("lazygit") end)
vim.keymap.set('n', '<leader>ll', function() run_term("lazygit log") end)
vim.keymap.set('n', '<leader>lq', function() run_term("lazygit -f %") end)

vim.keymap.set('n', '<leader>ld', function() run_term("lazydocker") end)
vim.keymap.set('n', '<leader>lf', function() run_term("lf %") end)
vim.keymap.set('n', '<leader>to', function() run_term(nil, string.format("%dsplit",vim.fn.winheight(0)/3+1)) end)
