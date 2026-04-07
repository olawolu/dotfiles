return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
      },
    },
    keys = {
      {
        "<leader>mF",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          vim.fn.system({ "markdownlint-cli2", "--fix", file })
          vim.cmd("checktime")
        end,
        desc = "Markdown fix",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
  },
}
