return {
  {
    "m4xshen/hardtime.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      disabled_filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "lspinfo",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  {
    "RaafatTurki/hex.nvim",
    enabled = false,
    lazy = false,
    opts = {},
  },
}
