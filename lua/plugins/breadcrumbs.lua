return {
  "LunarVim/breadcrumbs.nvim",
  config = function()
    require("breadcrumbs").setup()
  end,
  dependencies = { { "SmiteshP/nvim-navic" } },
}
