return {
  -- Color Schemes.
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
    end,
    init = function()
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    init = function()
      -- vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },
}
