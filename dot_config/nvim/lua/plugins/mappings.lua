return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>,"] = {
            function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd.wincmd "p"
              else
                vim.cmd.Neotree "focus"
              end
            end,
            desc = "Toggle Explorer Focus",
          },
          ----- OBSIDIAN -----
          ["<Leader>o"] = { desc = " Obsidian" },
          ["<Leader>oc"] = { "<cmd>ObsidianCheck<CR>", desc = "Obsidian Check Checkbox" },
          ["<Leader>ot"] = { "<cmd>ObsidianTemplate<CR>", desc = "Insert Obsidian Template" },
          ["<Leader>oo"] = { "<cmd>Obsidian Open<CR>", desc = "Open in Obsidian App" },
          ["<Leader>ob"] = { "<cmd>ObsidianBacklinks<CR>", desc = "Show ObsidianBacklinks" },
          ["<Leader>ol"] = { "<cmd>ObsidianLinks<CR>", desc = "Show ObsidianLinks" },
          ["<Leader>on"] = { "<cmd>ObsidianNew<CR>", desc = "Create New Note" },
          ["<Leader>os"] = { "<cmd>ObsidianSearch<CR>", desc = "Search Obsidian" },
          ["<Leader>oq"] = { "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch" },

          ----- OIL -----
          -- ["-"] = { "<cmd>Oil<CR>", desc = "Open parent directory" },

          ["<Leader>?"] = {
            function()
              require("which-key").show { global = false } -- Show the which-key popup for local keybindings
            end,
            desc = "Show Local Keybindings",
          },
        },
      },
    },
  },
  -- {
  --   "AstroNvim/astrolsp",
  --   ---@type AstroLSPOpts
  --   opts = {
  --     mappings = {
  --       n = {
  --         -- this mapping will only be set in buffers with an LSP attached
  --         K = {
  --           function()
  --             vim.lsp.buf.hover()
  --           end,
  --           desc = "Hover symbol details",
  --         },
  --         -- condition for only server with declaration capabilities
  --         gD = {
  --           function()
  --             vim.lsp.buf.declaration()
  --           end,
  --           desc = "Declaration of current symbol",
  --           cond = "textDocument/declaration",
  --         },
  --       },
  --     },
  --   },
  -- },
}
