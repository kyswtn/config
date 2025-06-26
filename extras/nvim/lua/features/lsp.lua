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

      vim.diagnostic.config({ virtual_text = false })
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
        html = {},
        cssls = {},
        jsonls = {},
        ts_ls = {
          settings = {},
        },
        zls = {},
        hls = {},
        gopls = {},
        golangci_lint_ls = {},
        terraformls = {},
        sourcekit = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
        biome = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
              files = {
                -- Otherwise, rust-analyzer get's excruciatingly slow.
                excludeDirs = { ".direnv", "node_modules" },
              },
            },
          },
        },
        ruff = {
          settings = {}
        }
      }

      for server_name, server_config in pairs(servers) do
        local resolved_config = vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, server_config)
        lspconfig[server_name].setup(resolved_config)
      end

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSign" .. "Error",
            [vim.diagnostic.severity.WARN] = "DiagnosticSign" .. "Warn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSign" .. "Hint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSign" .. "Info",
          },
        },
      })
    end,
  },
}
