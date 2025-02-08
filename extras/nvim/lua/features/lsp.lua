return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Add foldingRange capability for ufo.
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        opts.desc = "Goto definition"
        keymap.set("n", "gd", function()
          require("telescope.builtin").lsp_definitions({ reuse_win = true })
        end, opts)

        opts.desc = "Goto references"
        keymap.set("n", "gr", function()
          require("telescope.builtin").lsp_references()
        end, opts)

        opts.desc = "Goto declaration"
        keymap.set("n", "gD", function()
          vim.lsp.buf.declaration()
        end, opts)
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        astro = {
          init_options = {
            typescript = {
              tsdk = vim.fs.normalize("~/.global-npm-packages/lib/node_modules/typescript/lib/"),
            },
          },
        },
        bashls = {},
        clangd = {},
        nil_ls = {},
        marksman = {},
        -- tailwindcss = {},
        html = {},
        cssls = {},
        pylsp = {},
        jsonls = {},
        ts_ls = {
          settings = {},
        },
        zls = {},
        hls = {},
        gopls = {},
        golangci_lint_ls = {},
        terraformls = {},
        biome = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                -- Otherwise, rust-analyzer get's excruciatingly slow.
                excludeDirs = { ".direnv", "node_modules" },
              },
            },
          },
        },
      }

      for server_name, server_config in pairs(servers) do
        local resolved_config = vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, server_config)
        lspconfig[server_name].setup(resolved_config)
      end

      -- Set gutter signs.
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
