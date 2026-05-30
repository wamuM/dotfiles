vim.lsp.enable("lua_ls")

vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("jdtls")
vim.lsp.enable("rust-analyzer")

vim.lsp.config("emmet-language-server", {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  },
  root_markers = { ".git" },
})

