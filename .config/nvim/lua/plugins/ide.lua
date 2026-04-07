return {
  -- A neovim plugin to persist and toggle multiple terminals during an editing session
  -- {
  --   "akinsho/toggleterm.nvim",
  --   version = "*",
  --   opts = {
  --     size = 20,
  --     open_mapping = [[<C-\>]],
  --     shade_terminals = true,
  --     persist_mode = false,
  --     direction = "float",
  --   },
  -- },

  -- A completion engine plugin for neovim
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  -- Fast and feature-rich surround actions
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-t>]],
      direction = "float",
      start_in_insert = true,
      insert_mappings = true,
      close_on_exit = false,
      persist_size = true,
      float_opts = {
        border = "curved",
        width = 60,
        col = function()
          return vim.o.columns - 62
        end,
        row = function()
          local height = 18
          local bottom_margin = 2
          return vim.o.lines - height - bottom_margin
        end,
      },
      on_open = function(term)
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
          buffer = term.bufnr,
          silent = true,
        })
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = term.bufnr, silent = true })
      end,
      -- open_mapping = [[<c-t>]],
      -- direction = "vertical",
      -- size = 60,
      -- start_in_insert = true,
      -- persist_mode = false,
      -- insert_mappings = true,
      -- close_on_exit = false,
      -- persist_size = true,
      -- on_open = function(term)
      --   vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
      --     buffer = term.bufnr,
      --     silent = true,
      --   })
      --   vim.keymap.set("n", "q", "<cmd>close<cr>", {
      --     buffer = term.bufnr,
      --     silent = true,
      --   })
      -- end,
    },
  },
}
