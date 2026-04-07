return {
  -- add kanagawa
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  -- {
  --   "ricardoraposo/nightwolf.nvim",
  --   -- lazy = false
  --   -- priority = 1000,
  --   opts = {
  --     theme = "dark-gray", -- 'black', 'dark-blue', 'gray', 'dark-gray', 'light'
  --     italic = true,
  --     transparency = false,
  --     palette_overrides = {},
  --     highlight_overrides = {},
  --   },
  -- },
  -- {
  --   "forest-nvim/sequoia.nvim",
  --   -- lazy = false,
  --   -- priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme sequoia-night") -- or 'sequoia-night' / 'sequoia-rise'
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
