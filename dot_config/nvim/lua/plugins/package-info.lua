return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "json",
  config = function()
    require("package-info").setup({
      package_manager = "bun",
      hide_up_to_date = true,
      colors = {
        outdated = "#db4b4b",
      },
    })
  end,
  keys = {
    {
      "<leader>cps",
      function()
        require("package-info").show()
      end,
      desc = "Show dependency versions",
    },
    {
      "<leader>cpc",
      function()
        require("package-info").hide()
      end,
      desc = "Hide dependency versions",
    },
    {
      "<leader>cpt",
      function()
        require("package-info").toggle()
      end,
      desc = "Toggle dependency versions",
    },
    {
      "<leader>cpu",
      function()
        require("package-info").update()
      end,
      desc = "Update dependency on the line",
    },
    {
      "<leader>cpd",
      function()
        require("package-info").delete()
      end,
      desc = "Delete dependency on the line",
    },
    {
      "<leader>cpi",
      function()
        require("package-info").install()
      end,
      desc = "Install a new dependency",
    },
    {
      "<leader>cpp",
      function()
        require("package-info").change_version()
      end,
      desc = "Install a different dependency version",
    },
  },
}
