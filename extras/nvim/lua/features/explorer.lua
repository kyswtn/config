return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    tag = "3.14",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float" })
        end,
        desc = "Open file explorer",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left" })
        end,
        desc = "Open file explorer (left)",
      },
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      window = {
        position = "float",
        width = 35,
        mappings = {
          ["<space>"] = "none",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".DS_Store",
            ".git",
          },
          always_show = {
            ".env",
          },
        },
      },
      default_component_configs = {
        icon = {
          default = "󰛄",
        },
        git_status = {
          symbols = {
            -- Change type.
            added = "",
            modified = "",
            deleted = "✗", -- This can only be used in the git_status source.
            renamed = "→", -- This can only be used in the git_status source.
            -- Status type.
            untracked = "?",
            ignored = "",
            unstaged = "☐",
            staged = "☑︎",
            conflict = "☒",
          },
        },
      },
    },
    deactivate = function()
      vim.cmd("Neotree close")
    end,
  },
}
