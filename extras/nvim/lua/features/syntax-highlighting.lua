return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      local opts = {
        ensure_installed = {
          -- treesitter
          "query",

          -- vim
          "lua",
          "vim",
          "vimdoc",

          -- web
          "html",
          "css",
          "javascript",
          "typescript",
          "json",
          "jsonc",
          "markdown",
          "astro",

          -- shell
          "bash",
          "fish",

          -- system
          "asm",
          "linkerscript",
          "nix",
          "c",
          "make",
          "cpp",
          "rust",
          "zig",
          "go",
          "swift",

          -- config
          "terraform",
          "toml",
          "hcl",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
      }

      configs.setup(opts)
    end,
  },

  -- Semantic highlighting.
  -- Use this (sometimes) instead of the one provided by LSP because it's slow & flash.
  {
    "m-demare/hlargs.nvim",
    enabled = false,
    init = function()
      local hlargs = require("hlargs")
      hlargs.setup()
    end,
  },
}
