return {
  {
    "stevearc/dressing.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    init = function()
      local dressing = require("dressing")

      dressing.setup({
        select = {
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                backend = "telescope",
                trim_prompt = true,
                telescope = require("telescope.themes").get_cursor({
                  prompt_title = false,
                }),
              }
            end
          end,
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    init = function()
      require("noice").setup({
        presets = {
          lsp_doc_border = true,
        },
        messages = {
          enabled = false,
        },
        notify = {
          enabled = false,
        },
        cmdline = {
          enabled = false,
        },
        popupmenu = {
          enabled = false,
        },
        lsp = {
          signature = {
            -- This was one of the most annoying thing ever.
            auto_open = { enabled = false },
          },
        },
      })
    end,
  },
}
