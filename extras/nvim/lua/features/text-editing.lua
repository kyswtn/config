return {
  -- Surround stuff
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  -- Toggle checkboxes
  {
    "opdavies/toggle-checkbox.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Bracket pairing.
  {
    "echasnovski/mini.pairs",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Comments.
  {
    "echasnovski/mini.comment",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- Highlight colors.
  {
    "brenoprata10/nvim-highlight-colors",
    enabled = false, -- I haven't had a need to work with colors in a while.
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
