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

      telescope.load_extension("fzf")
      telescope.setup({
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
    end,
  },
}
