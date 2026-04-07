-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("scope").setup({})
vim.lsp.enable("gopls")
vim.lsp.enable("typescript")
