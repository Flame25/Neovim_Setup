return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    { "b0o/schemastore.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(require("plugins.lsp.servers")),
    })
    require("lspconfig.ui.windows").default_options.border = "single"

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        map("go", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        map("<leader>p", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")
        map("<leader>Ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local wk = require("which-key")
        wk.add({
          { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>lA", vim.lsp.buf.range_code_action, desc = "Range Code Actions" },
          { "<leader>ls", vim.lsp.buf.signature_help, desc = "Display Signature Information" },
          { "<leader>lr", vim.lsp.buf.rename, desc = "Rename all references" },
          { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
          { "<leader>li", require("telescope.builtin").lsp_implementations, desc = "Implementation" },
          { "<leader>lw", require("telescope.builtin").diagnostics, desc = "Diagnostics" },
          { "<leader>lc", require("config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },

          -- W = {
          --   name = "+Workspace",
          --   a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
          --   r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
          --   l = {
          --     function()
          --       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          --     end,
          --     "List Folders",
          --   },
          -- },

          { "<leader>Wa", vim.lsp.buf.add_workspace_folder, desc = "Workspace Add Folder" },
          { "<leader>Wr", vim.lsp.buf.remove_workspace_folder, desc = "Workspace Remove Folder" },
          {
            "<leader>Wl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "Workspace List Folders",
          },
        })

        -- Thank you teej
        -- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L502
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client and client.server_capabilities.documentHighlightProvider then
        --   local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })
        --   vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        --     buffer = event.buf,
        --     group = highlight_augroup,
        --     callback = vim.lsp.buf.document_highlight,
        --   })
        --
        --   vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        --     buffer = event.buf,
        --     group = highlight_augroup,
        --     callback = vim.lsp.buf.clear_references,
        --   })
        --   vim.api.nvim_create_autocmd("LspDetach", {
        --     group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
        --     callback = function(event2)
        --       vim.lsp.buf.clear_references()
        --       vim.api.nvim_clear_autocmds({ group = "nvim-lsp-highlight", buffer = event2.buf })
        --     end,
        --   })
        -- end
      end,
    })

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local mason_lspconfig = require("mason-lspconfig")
    local navic = require("nvim-navic")

    --mason_lspconfig.setup_handlers {
    --  function(server_name)
    --    local server_config = require("plugins.lsp.servers")[server_name]
    --    require("lspconfig")[server_name].setup {
    --      capabilities = capabilities,
    --      -- on_attach = require("plugins.lsp.on_attach").on_attach,
    --      on_attach = function(client, bufnr)
    --        navic.attach(client, bufnr)
    --      end,
    --      settings = require("plugins.lsp.servers")[server_name],
    --      filetypes = (require("plugins.lsp.servers")[server_name] or {}).filetypes,
    --    }
    --  end,
    --}

    -- Gleam LSP
    -- For some reason mason doesn't work with gleam lsp
    require("lspconfig").gleam.setup({
      cmd = { "gleam", "lsp" },
      filetypes = { "gleam" },
      root_dir = require("lspconfig").util.root_pattern("gleam.toml", ".git"),
      capabilities = capabilities,
    })

    require("lspconfig").arduino_language_server.setup({
      cmd = {
        "arduino-language-server",
        "-cli",
        "arduino-cli",
        "-cli-config",
        "/home/gadzz/.arduino15/arduino-cli.yaml",
        "--fqbn",
        "esp32:esp32:esp32", -- Ensure this FQBN is 100% correct
        "-log",
        "debug",
        "-cli-daemon",
        "true",
      },
      filetypes = { "arduino" },
      root_dir = function(fname)
        return vim.fn.getcwd()
      end,
    })

    require("lspconfig").lua_ls.setup({
      on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end,
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    vim.diagnostic.config({
      title = false,
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "if_many",
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
