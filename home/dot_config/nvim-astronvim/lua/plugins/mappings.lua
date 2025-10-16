--- Toggle a language in vim.opt.spelllang
---@param lang string The language code to toggle (e.g., "es_mx")
local function toggle_spelllang(lang)
  local spelllang = vim.opt.spelllang:get()
  local found = false

  for i, l in ipairs(spelllang) do
    if l == lang then
      table.remove(spelllang, i)
      found = true
      break
    end
  end

  if not found then table.insert(spelllang, lang) end

  vim.opt.spelllang = spelllang
end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>?"] = {
            function()
              require("which-key").show { global = false } -- Show the which-key popup for local keybindings
            end,
            desc = "Show Local Keybindings",
          },
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

          -- ╭─────────────────────────────────────────────────────────╮
          -- │                       COMMENT-BOX                       │
          -- ╰─────────────────────────────────────────────────────────╯
          ["<Leader>;"] = { desc = "Boxes" },

          ["<Leader>;b"] = { desc = "Box Title" },
          ["<Leader>;bl"] = { desc = "Left aligned" },
          ["<Leader>;bll"] = { "<Cmd>CBllbox<CR>", desc = "Left aligned box with Left aligned text" },
          ["<Leader>;blc"] = { "<Cmd>CBlcbox<CR>", desc = "Left aligned box with Centered text" },
          ["<Leader>;blr"] = { "<Cmd>CBlrbox<CR>", desc = "Left aligned box with Right aligned text" },
          ["<Leader>;bc"] = { desc = "Centered" },
          ["<Leader>;bcl"] = { "<Cmd>CBclbox<CR>", desc = "Centered box with Left aligned text" },
          ["<Leader>;bcc"] = { "<Cmd>CBccbox<CR>", desc = "Centered box with Centered text" },
          ["<Leader>;bcr"] = { "<Cmd>CBcrbox<CR>", desc = "Centered box with Right aligned text" },
          ["<Leader>;br"] = { desc = "Right aligned" },
          ["<Leader>;brl"] = { "<Cmd>CBrlbox<CR>", desc = "Right aligned box with Left aligned text" },
          ["<Leader>;brc"] = { "<Cmd>CBrcbox<CR>", desc = "Right aligned box with Centered text" },
          ["<Leader>;brr"] = { "<Cmd>CBrrbox<CR>", desc = "Right aligned box with Right aligned text" },
          ["<Leader>;ba"] = { desc = "Adapted Box" },
          ["<Leader>;bal"] = { "<Cmd>CBllabox<CR>", desc = "Left aligned adapted box with Left aligned text" },
          ["<Leader>;bac"] = { "<Cmd>CBcabox<CR>", desc = "Centered adapted box with Centered text" },
          ["<Leader>;bar"] = { "<Cmd>CBrabox<CR>", desc = "Right aligned adapted box with Right aligned text" },

          ["<Leader>;t"] = { desc = "Titled Line" },
          ["<Leader>;tl"] = { desc = "Left aligned" },
          ["<Leader>;tll"] = { "<Cmd>CBllline<CR>", desc = "Left aligned titled line with Left aligned text" },
          ["<Leader>;tlc"] = { "<Cmd>CBlcline<CR>", desc = "Left aligned titled line with Centered text" },
          ["<Leader>;tlr"] = { "<Cmd>CBlrline<CR>", desc = "Left aligned titled line with Right aligned text" },
          ["<Leader>;tc"] = { desc = "Centered" },
          ["<Leader>;tcl"] = { "<Cmd>CBclline<CR>", desc = "Centered title line with Left aligned text" },
          ["<Leader>;tcc"] = { "<Cmd>CBccline<CR>", desc = "Centered titled line with Centered text" },
          ["<Leader>;tcr"] = { "<Cmd>CBcrline<CR>", desc = "Centered titled line with Right aligned text" },
          ["<Leader>;tr"] = { desc = "Right aligned" },
          ["<Leader>;trl"] = { "<Cmd>CBrlline<CR>", desc = "Right aligned titled line with Left aligned text" },
          ["<Leader>;trc"] = { "<Cmd>CBrcline<CR>", desc = "Right aligned titled line with Centered text" },
          ["<Leader>;trr"] = { "<Cmd>CBrrline<CR>", desc = "Right aligned titled line with Right aligned text" },
          ["<Leader>;l"] = { "<Cmd>CBline<CR>", desc = "Simple Line" },
          ["<Leader>;m"] = { "<Cmd>CBllbox14<CR>", desc = "Marked" },
          ["<Leader>;d"] = { "<Cmd>CBd<CR>", desc = "Remove a box" },

          -- ╭─────────────────────────────────────────────────────────╮
          -- │                           OIL                           │
          -- ╰─────────────────────────────────────────────────────────╯
          -- ["-"] = { "<cmd>Oil<CR>", desc = "Open parent directory" },

          -- ╭─────────────────────────────────────────────────────────╮
          -- │                        MARKDOWN                         │
          -- ╰─────────────────────────────────────────────────────────╯
          ["<Leader>m"] = { desc = " Markdown" },
          ["<Leader>mf"] = { desc = "Fold" },
          ["<Leader>mh"] = { desc = "Headings increase/decrease" },
          ["<Leader>ml"] = { desc = "Links" },
          -- ── OBSIDIAN ────────────────────────────────────────────────────────
          ["<Leader>mo"] = { desc = "Obsidian" },
          ["<Leader>moc"] = { "<cmd>ObsidianCheck<CR>", desc = "Obsidian Check Checkbox" },
          ["<Leader>mot"] = { "<cmd>ObsidianTemplate<CR>", desc = "Insert Obsidian Template" },
          ["<Leader>moo"] = { "<cmd>Obsidian Open<CR>", desc = "Open in Obsidian App" },
          ["<Leader>mob"] = { "<cmd>ObsidianBacklinks<CR>", desc = "Show ObsidianBacklinks" },
          ["<Leader>mol"] = { "<cmd>ObsidianLinks<CR>", desc = "Show ObsidianLinks" },
          ["<Leader>mon"] = { "<cmd>ObsidianNew<CR>", desc = "Create New Note" },
          ["<Leader>mos"] = { "<cmd>ObsidianSearch<CR>", desc = "Search Obsidian" },
          ["<Leader>moq"] = { "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch" },
          -- ── SPELL ───────────────────────────────────────────────────────────
          ["<Leader>ms"] = { desc = "Spell" },
          ["<Leader>msl"] = { desc = "Language" },
          ["<Leader>msle"] = {
            function()
              vim.opt.spelllang = "en_us"
              vim.cmd "echo 'Spell language set to English'"
            end,
            desc = "Set spell language to English",
          },
          ["<Leader>mslE"] = {
            function()
              toggle_spelllang "en_us"
              vim.cmd "echo 'Toggled English spell language'"
            end,
            desc = "Toggle English spell language",
          },
          ["<Leader>msls"] = {
            function()
              vim.opt.spelllang = "es_mx"
              vim.cmd "echo 'Spell language set to Spanish'"
            end,
            desc = "Set spell language to Spanish",
          },
          ["<Leader>mslS"] = {
            function()
              toggle_spelllang "es_mx"
              vim.cmd "echo 'Toggled Spanish spell language'"
            end,
            desc = "Toggle Spanish spell language",
          },
          ["<Leader>mslg"] = {
            function()
              vim.opt.spelllang = "de"
              vim.cmd "echo 'Spell language set to German'"
            end,
            desc = "Set spell language to German",
          },
          ["<Leader>mslG"] = {
            function()
              toggle_spelllang "de"
              vim.cmd "echo 'Toggled German spell language'"
            end,
            desc = "Toggle German spell language",
          },
          ["<Leader>msla"] = {
            function()
              vim.opt.spelllang = { "en_us", "es_mx", "de" }
              vim.cmd "echo 'Spell language set to English, Spanish, and German'"
            end,
            desc = "Set spell language to English, Spanish, and German",
          },
          ["<Leader>mslr"] = {
            function()
              vim.opt.spelllang = { "en_us" }
              vim.cmd "echo 'Spell language set to English only'"
            end,
            desc = "Reset to default spell language (English)",
          },
          -- ["<Leader>mslts"] = {
          --   function()
          --     local spelllang = vim.opt.spelllang:get()
          --     if type(spelllang) == "string" then spelllang = { spelllang } end
          --     require("astrocore").list_insert_unique(spelllang, { "es_mx" })
          --     vim.opt.spelllang = spelllang
          --     vim.cmd "echo 'Added Spanish spell language'"
          --   end,
          --   desc = "Toggle Spanish spell language",
          -- },
          -- ["<Leader>mslte"] = {
          --   function()
          --     local spelllang = vim.opt.spelllang:get()
          --     if type(spelllang) == "string" then spelllang = { spelllang } end
          --     require("astrocore").list_insert_unique(spelllang, { "en_us" })
          --     vim.opt.spelllang = spelllang
          --     vim.cmd "echo 'Added English spell language'"
          --   end,
          --   desc = "Toggle English spell language",
          -- },
          -- ["<Leader>msltg"] = {
          --   function()
          --     local spelllang = vim.opt.spelllang:get()
          --     if type(spelllang) == "string" then spelllang = { spelllang } end
          --     require("astrocore").list_insert_unique(spelllang, { "de" })
          --     vim.opt.spelllang = spelllang
          --     vim.cmd "echo 'Added German spell language'"
          --   end,
          --   desc = "Toggle German spell language",
          -- },
          ["<Leader>mss"] = {
            function()
              -- Simulate pressing "z=" with "m" option using feedkeys
              -- vim.api.nvim_replace_termcodes ensures "z=" is correctly interpreted
              -- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
              -- If {mode} is absent, keys are remapped.
              --
              -- I tried this keymap as usually with
              vim.cmd "normal! 1z="
              -- But didn't work, only with nvim_feedkeys
              -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
            end,
            desc = "Spelling suggestions",
          },
          ["<Leader>msg"] = {
            function()
              vim.cmd "normal! zg"
              -- I do a write so that harper is updated
              vim.cmd "silent write"
            end,
            desc = "Add word to spell check dictionary",
          },
          ["<Leader>msu"] = {
            function() vim.cmd "normal! zug" end,
            desc = "Undo word from spell check dictionary",
          },
          ["<Leader>msr"] = {
            function()
              -- vim.cmd(":spellr")
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
            end,
            desc = "Spelling replace all",
          },

          -- By default, CTRL-U and CTRL-D scroll by half a screen (50% of the window height)
          -- Scroll by 35% of the window height and keep the cursor centered
          -- Scroll by a percentage of the window height and keep the cursor centered
          -- ["<C-d>"] = {
          --   function()
          --     local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
          --     vim.cmd("normal! " .. lines .. "jzz")
          --   end,
          --   noremap = true,
          --   silent = true,
          -- },
          -- ["<C-u>"] = {
          --   function()
          --     local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
          --     vim.cmd("normal! " .. lines .. "kzz")
          --   end,
          --   noremap = true,
          --   silent = true,
          -- },
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
