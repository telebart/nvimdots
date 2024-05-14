require("mini.notify").setup({
  window = {
    config = { border = "none", },
    winblend = 0,
  }
})
require("mini.surround").setup()
require("mini.extra").setup()
require("mini.splitjoin").setup({
  mappings = {
    toggle = "gs"
  }
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(args)
    local from = args.data.from
    local to = args.data.to
    if not from or not to then return end
    local clients = vim.lsp.get_clients()
    for _, client in ipairs(clients) do
      if client.supports_method("workspace/didRenameFiles") then
        ---@diagnostic disable-next-line: invisible
        client.notify("workspace/didRenameFiles", {
          files = {
            {
              oldUri = vim.uri_from_fname(args.data.from),
              newUri = vim.uri_from_fname(args.data.to),
            },
          },
        })
      end
    end
  end,
})
