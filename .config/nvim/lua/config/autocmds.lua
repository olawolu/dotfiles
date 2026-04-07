-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local timer = nil

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
  callback = function()
    if not vim.g.auto_save then
      return
    end

    -- stop & cleanup existing timer safely
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end

    timer = vim.uv.new_timer()
    if not timer then
      return
    end

    timer:start(
      1000,
      0,
      vim.schedule_wrap(function()
        -- buffer safety checks
        if vim.bo.modified and vim.bo.modifiable and vim.bo.buftype == "" then
          vim.cmd("silent! write")
        end
      end)
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

--   callback = function()
--     local opts = { buffer = 0 }
--
--     vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
--     vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
--     vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
--     vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
--     vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
--     vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
--
--     vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
--   end,
-- })
