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

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("l_auto_format", { clear = true }),
  pattern = {"*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.graphql", "*.tf"},
  callback = function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
    })
    vim.api.nvim_command('write')
    end ,
})

local function run_term(prog)
  if prog == "lf" then
    vim.env.LFCD = nil
    local path = vim.api.nvim_buf_get_name(0)
    prog = prog .. " " .. path
  end
  vim.cmd("term " .. prog)
  local buf_num = vim.api.nvim_get_current_buf()
  vim.opt_local.spell = false
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.api.nvim_input("i")
  vim.api.nvim_create_autocmd("TermClose", {
    group = vim.api.nvim_create_augroup("l_term_close", { clear = true }),
    callback = function()
      vim.api.nvim_buf_delete(buf_num, {})
      if vim.env.LFCD then
        vim.defer_fn(function ()
          vim.cmd("e " .. vim.env.LFCD)
          vim.env.LFCD = nil
        end, 0)
      end
    end,
  })
end

vim.keymap.set('n', '<leader>lg', function() run_term("lazygit") end)
vim.keymap.set('n', '<leader>lf', function() run_term("lf") end)
