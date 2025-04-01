return {
  -- Color Schemes.
  {
    "sainnhe/gruvbox-material",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_transparent_background = true
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = false,
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
      -- vim.cmd.colorscheme("rose-pine")
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
