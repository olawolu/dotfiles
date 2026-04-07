-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local win_mover = require("win-mover")
win_mover.setup({
  ignore = {
    enable = true,
    filetypes = { "NvimTree", "neo-tree", "Outline", "toggleterm" },
  },
  move_mode = {
    keymap = {
      h = win_mover.ops.move_left,
      j = win_mover.ops.move_down,
      k = win_mover.ops.move_up,
      l = win_mover.ops.move_right,

      H = win_mover.ops.move_far_left,
      J = win_mover.ops.move_far_down,
      K = win_mover.ops.move_far_up,
      L = win_mover.ops.move_far_right,

      q = win_mover.ops.quit,
      ["<Esc>"] = win_mover.ops.quit,
    },
  },
})

vim.keymap.set("n", "<leader>m", win_mover.enter_move_mode, { noremap = true, silent = true })

-- local toggleterm = require("toggleterm")
-- toggleterm.setup({
--   open_mapping = [[<c-t>]],
--   direction = "float",
--   float_opts = {
--     border = "curved",
--     width = 60,
--     col = 110,
--   },
-- })
