return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  opts = {
    -- Configuration options (optional)
  },
  keys = {
    {
      "K", -- or any key you prefer
      function()
        require("diagram").show_diagram_hover()
      end,
      mode = "n",
      ft = { "markdown", "norg" }, -- Only in these filetypes
      desc = "Show diagram in new tab",
    },
  },
}
