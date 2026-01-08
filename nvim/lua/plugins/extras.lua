return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {},
    config = function()
      -- This is where you call the setup function for indent-blankline version 3
      require("ibl").setup({
        indent = {
          char = "│",
          smart_indent_cap = true,
        },
        scope = {
          show_start = true,
          show_end = true,
        },
        exclude = {
          filetypes = { "dashboard", "lazy", "NvimTree", "alpha" },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      })
    end,
  },

  -- Lua
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end,
  },

  -- { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'warm'
      }
      -- Enable theme
      require('onedark').load()
    end
  },
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
      require("goto-preview").setup({
        width = 120, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        same_file_float_preview = true, -- Whether to open a new floating window for a reference within the current file
        preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
        zindex = 1, -- Starting zindex for the stack of floating windows
      })
    end,
  },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = function()
      require("tiny-glimmer").setup({
        enabled = true,

        -- Disable this if you wants to debug highlighting issues
        disable_warnings = true,

        refresh_interval_ms = 8,

        overwrite = {
          -- Automatically map keys to overwrite operations
          -- If set to false, you will need to call the API functions to trigger the animations
          -- WARN: You should disable this if you have already mapped these keys
          --        or if you want to use the API functions to trigger the animations
          auto_map = true,

          -- For search and paste, you can easily modify the animation to suit your needs
          -- For example you can set a table to default_animation with custom parameters:
          -- default_animation = {
          --     name = "fade",
          --
          --     settings = {
          --         max_duration = 1000,
          --         min_duration = 1000,
          --
          --         from_color = "DiffDelete",
          --         to_color = "Normal",
          --     },
          -- },
          -- settings needs to respect the animation you choose settings
          --
          -- All "mapping" can be set in 2 ways:
          -- 1. A string with the key you want to map
          --    Example:
          --    paste_mapping = "p"
          -- 2. A table with the key you want to map and its actions
          --    Example:
          --    paste_mapping = {
          --        lhs = "p"
          --        rhs = "<Plug>(YankyPutAfter)"
          --    }
          yank = {
            enabled = false,
            default_animation = "fade",
          },
          search = {
            enabled = false,
            default_animation = "pulse",

            -- Keys to navigate to the next match
            next_mapping = "nzzzv",

            -- Keys to navigate to the previous match
            prev_mapping = "Nzzzv",
          },
          paste = {
            enabled = true,
            default_animation = "reverse_fade",

            -- Keys to paste
            paste_mapping = "p",

            -- Keys to paste above the cursor
            Paste_mapping = "P",
          },
          undo = {
            enabled = true,

            default_animation = {
              name = "fade",

              settings = {
                from_color = "DiffDelete",

                max_duration = 500,
                min_duration = 500,
              },
            },
            undo_mapping = "u",
          },
          redo = {
            enabled = true,

            default_animation = {
              name = "fade",

              settings = {
                from_color = "DiffAdd",

                max_duration = 500,
                min_duration = 500,
              },
            },

            redo_mapping = "<c-r>",
          },
        },

        support = {
          -- Enable support for gbprod/substitute.nvim
          -- You can use it like so:
          -- require("substitute").setup({
          --     on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
          --     highlight_substituted_text = {
          --         enabled = false,
          --     },
          --})
          substitute = {
            enabled = false,

            -- Can also be a table. Refer to overwrite.search for more information
            default_animation = "fade",
          },
        },

        -- Animations for other operations
        presets = {
          -- Enable animation on cursorline when an event in `on_events` is triggered
          -- Similar to `pulsar.el`
          pulsar = {
            enabled = false,
            on_events = { "CursorMoved", "CmdlineEnter", "WinEnter" },
            default_animation = {
              name = "fade",

              settings = {
                max_duration = 1000,
                min_duration = 1000,

                from_color = "DiffDelete",
                to_color = "Normal",
              },
            },
          },
        },

        -- Only use if you have a transparent background
        -- It will override the highlight group background color for `to_color` in all animations
        transparency_color = nil,
        -- Animation configurations
        animations = {
          fade = {
            max_duration = 400,
            min_duration = 300,
            easing = "outQuad",
            chars_for_max_duration = 10,
            from_color = "Visual", -- Highlight group or hex color
            to_color = "Normal", -- Same as above
          },
          reverse_fade = {
            max_duration = 380,
            min_duration = 300,
            easing = "outBack",
            chars_for_max_duration = 10,
            from_color = "Visual",
            to_color = "Normal",
          },
          bounce = {
            max_duration = 500,
            min_duration = 400,
            chars_for_max_duration = 20,
            oscillation_count = 1,
            from_color = "Visual",
            to_color = "Normal",
          },
          left_to_right = {
            max_duration = 350,
            min_duration = 350,
            min_progress = 0.85,
            chars_for_max_duration = 25,
            lingering_time = 50,
            from_color = "Visual",
            to_color = "Normal",
          },
          pulse = {
            max_duration = 600,
            min_duration = 400,
            chars_for_max_duration = 15,
            pulse_count = 2,
            intensity = 1.2,
            from_color = "Visual",
            to_color = "Normal",
          },
          rainbow = {
            max_duration = 600,
            min_duration = 350,
            chars_for_max_duration = 20,
          },

          -- You can add as many animations as you want
          custom = {
            -- You can also add as many custom options as you want
            -- Only `max_duration` and `chars_for_max_duration` is required
            max_duration = 350,
            chars_for_max_duration = 40,

            color = hl_visual_bg,

            -- Custom effect function
            -- @param self table The effect object
            -- @param progress number The progress of the animation [0, 1]
            --
            -- Should return a color and a progress value
            -- that represents how much of the animation should be drawn
            -- self.settings represents the settings of the animation that you defined above
            effect = function(self, progress)
              return self.settings.color, progress
            end,
          },
          hijack_ft_disabled = {
            "alpha",
            "snacks_dashboard",
          },
        },
        virt_text = {
          priority = 2048,
        },
      })
    end,
  },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      })
      -- === Suggested Keymaps: ===
      local namu = require("namu.namu_symbols")
      local colorscheme = require("namu.colorscheme")
      vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
      })
      vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", {
        desc = "Colorscheme Picker",
        silent = true,
      })
    end,
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = { "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha" }, -- Your list of installed colorschemes.
        livePreview = true, -- Apply theme while picking. Default to true.
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  { 
    "RutaTang/quicknote.nvim", 
    config=function()
        require("quicknote").setup({
            mode = "portable", -- "portable" | "resident", default to "portable"
            sign = "N", -- This is used for the signs on the left side (refer to ShowNoteSigns() api).
                       -- You can change it to whatever you want (eg. some nerd fonts icon), 'N' is default
            filetype = "md",
            git_branch_recognizable = true, -- If true, quicknote will separate notes by git branch 
                                            -- But it should only be used with resident mode,  it has not effect used with portable mode
        })
    end, 
    dependencies = { "nvim-lua/plenary.nvim"} 
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
}


