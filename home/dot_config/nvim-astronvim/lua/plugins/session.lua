return {
  "stevearc/resession.nvim",
  opts = {
    options = {
      "spell",
      "spelllang",
    },
    hooks = {
      pre_save = function()
        -- Add any pre-save logic here if needed
      end,
      post_load = function()
        -- Add any post-load logic here if needed
      end,
    },
  },
}
