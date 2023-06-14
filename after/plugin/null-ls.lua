local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    --null_ls.builtins.code_actions.gomodifytags,
    --null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.gofumpt,
    --null_ls.builtins.diagnostics.revive,
    --null_ls.builtins.code_actions.gitsigns,null

    --null_ls.builtins.diagnostics.tfsec,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
  }
})
