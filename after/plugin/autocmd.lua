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

local laststatus = vim.opt.laststatus

vim.api.nvim_create_autocmd('TermEnter', {
  callback = function()
    vim.opt.laststatus = 0
  end,
})

vim.api.nvim_create_autocmd('TermLeave', {
  callback = function()
    vim.opt.laststatus = laststatus
  end,
})

local function run_term(prog)
  vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup("l_term_open", { clear = true }),
    callback = function(args)
      vim.opt_local.spell = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
      vim.api.nvim_buf_call(args.buf, function()
        vim.api.nvim_input("i")
      end)
      vim.api.nvim_create_autocmd("TermClose", {
        group = vim.api.nvim_create_augroup("l_term_close", { clear = true }),
        buffer = args.buf,
        callback = function()
          vim.api.nvim_buf_delete(0, {})
        end,
      })
    end,
  })
  if not prog then
    vim.cmd("tabnew term://fish")
    return
  end
  if prog == "lf" then
    local path = vim.api.nvim_buf_get_name(0)
    prog = prog .. " " .. path
  end
  vim.cmd(string.format("tabnew term://%s -c %s",vim.opt.shell._value,prog))
end

vim.api.nvim_create_user_command("Term", function ()
  run_term()
end, {})

vim.keymap.set('n', '<leader>lg', function() run_term("lazygit") end)
vim.keymap.set('n', '<leader>ld', function() run_term("lazydocker") end)
vim.keymap.set('n', '<leader>lf', function() run_term("lf") end)
