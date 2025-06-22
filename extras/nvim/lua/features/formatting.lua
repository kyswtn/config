return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      stop_after_first = true,
      notify_on_error = false,
      notify_no_formatters = false,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        nix = { "nixpkgs_fmt" },
        sh = { "shfmt" },
        html = { "biome", "prettierd" },
        css = { "biome", "prettierd" },
        json = { "biome", "prettierd" },
        typescript = { "biome", "prettierd" },
        typescriptreact = { "biome", "prettierd" },
        javascript = { "biome", "prettierd" },
        javascriptreact = { "biome", "prettierd" },
        swift = { "swift_format" },
        -- Biome doesn't support these properly yet.
        markdown = { "prettierd" },
        astro = { "prettierd" },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat for now.
        -- if true then
        --   return
        -- end

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
