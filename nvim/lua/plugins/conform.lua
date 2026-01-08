return {
  "stevearc/conform.nvim",
  opts = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        javascript = { "prettierd", "prettier", stop_after_first = true },
        cpp = { "clang-format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        arduino = { "clang-format" },
        ino = { "clang-format" },
      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })
  end,
}
