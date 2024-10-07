return {
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    },
  },
}
