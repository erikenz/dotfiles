---@type LazySpec
return {
  "mrjones2014/smart-splits.nvim",
  opts = {
    -- Seamless navigation: move across Neovim splits, and if at edge, focus adjacent Herdr pane
    at_edge = function(ctx)
      local dir_map = { left = "left", down = "down", up = "up", right = "right" }
      local dir = dir_map[ctx.direction]
      if dir then
        vim.fn.system({ "herdr", "pane", "focus", "--current", "--direction", dir })
      end
    end,
  },
  keys = {
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split or Herdr pane" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to lower split or Herdr pane" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to upper split or Herdr pane" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split or Herdr pane" },
  },
}
