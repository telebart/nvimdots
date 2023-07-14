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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("l_spell", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
