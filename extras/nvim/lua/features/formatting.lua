return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        -- Essentials.
        lua = { "stylua" },
        nix = { "nixpkgs_fmt" },
        sh = { "shfmt" },

        -- Web stuff.
        html = { { "biome", "prettierd" } },
        css = { { "biome", "prettierd" } },
        json = { { "biome", "prettierd" } },
        typescript = { { "biome", "prettierd" } },
        typescriptreact = { { "biome", "prettierd" } },
        javascript = { { "biome", "prettierd" } },
        javascriptreact = { { "biome", "prettierd" } },
        markdown = { { "biome", "prettierd" } },

        -- Biome doesn't support astro yet.
        astro = { "prettierd" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        }
      end,
    },
  },
}
