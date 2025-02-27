local create_telescope_helix_layout = require("utils.telescope-helix-layout")

return {
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    init = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        extensions = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        defaults = {
          mappings = {
            i = {
              ["<c-e>"] = { "<esc>", type = "command" },
              ["<esc>"] = actions.close,
            },
          },
          create_layout = create_telescope_helix_layout,
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          prompt_prefix = " ",
          selection_caret = " > ",
          entry_prefix = "   ",
        },
      })
      telescope.load_extension("fzf")
    end,
  },
}
