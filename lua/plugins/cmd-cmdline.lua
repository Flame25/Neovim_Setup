return {
  {
    "folke/noice.nvim",
    lazy = true,
    enabled = true,
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
    event = "CmdlineEnter",
    opts = {
      messages = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        -- Preset ini menyesuaikan bentuk cursor pada mode commond
        command_bar_cursor = {
          enabled = true,
          cursor_shape = "ver30", -- "ver" menandakan bar vertikal, 30 adalah tinggi dalam persen
        },
      },
    },
    keys = {
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
    },
  },
  {
    "hrsh7th/cmp-cmdline",
    -- event = "VeryLazy",
    event = "CmdlineEnter",
    config = function()
      local cmp = require("cmp")
      local mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      }

      -- Use buffer source for `/`.
      cmp.setup.cmdline("/", {
        preselect = "none",
        completion = {
          completeopt = "menu,preview,menuone,noselect",
        },
        mapping = mapping,
        sources = {
          { name = "buffer" },
        },
        experimental = {
          ghost_text = true,
          native_menu = false,
        },
      })

      -- Use cmdline & path source for ':'.
      cmp.setup.cmdline(":", {
        preselect = "none",
        completion = {
          completeopt = "menu,preview,menuone,noselect",
        },
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        experimental = {
          ghost_text = true,
          native_menu = false,
        },
      })
    end,
  },
}
