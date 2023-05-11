-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup("formatgo", { clear = true }),
  pattern = {"*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.graphql", "*.tf"},
  callback = function()
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
    })
    vim.api.nvim_command('write')
    end ,
})
