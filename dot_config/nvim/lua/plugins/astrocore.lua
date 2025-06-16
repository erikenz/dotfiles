-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

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

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    local sessionoptions = { "localoptions" } -- https://github.com/thaerkh/vim-workspace/issues/11
    for _, value in ipairs(vim.tbl_get(opts, "options", "opt", "sessionoptions") or vim.opt.sessionoptions:get()) do
      if value ~= "blank" then table.insert(sessionoptions, value) end
    end
    return require("astrocore").extend_tbl(opts, {
      -- Configure core features of AstroNvim
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
      },
      -- Configuration table of session options for AstroNvim's session management powered by Resession
      sessions = {
        -- Configure auto saving
        autosave = {
          last = true, -- auto save last session
          cwd = true, -- auto save session for each working directory
        },
        -- Patterns to ignore when saving sessions
        ignore = {
          dirs = {}, -- working directories to ignore sessions in
          filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
          buftypes = {}, -- buffer types to ignore sessions
        },
      },
      autocmds = {
        restore_session = {
          {
            event = "VimEnter",
            desc = "Restore previous directory session if neovim opened with no arguments",
            nested = true, -- trigger other autocommands as buffers open
            callback = function()
              -- Only load the session if nvim was started with no args
              if vim.fn.argc(-1) == 0 then
                -- try to load a directory session using the current working directory
                require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
              end
            end,
          },
        },
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      -- passed to `vim.filetype.add`
      filetypes = {
        -- see `:h vim.filetype.add` for usage
        extension = {
          foo = "fooscript",
        },
        filename = {
          [".foorc"] = "fooscript",
        },
        pattern = {
          [".*/etc/foo/.*"] = "fooscript",
        },
      },
      -- vim options can be configured here
      options = {
        opt = { -- vim.opt.<key>
          relativenumber = true, -- sets vim.opt.relativenumber
          number = true, -- sets vim.opt.number
          spell = false, -- sets vim.opt.spell
          -- spelllang = { "en_us", "es_mx", "de" }, -- sets vim.opt.spelllang
          -- I mainly type in english, if I set it to both above, files in English get a
          -- bit confused and recognize words in spanish, just for spanish files I need to
          -- set it to both
          spelllang = { "en_us" }, -- sets vim.opt.spelllang
          signcolumn = "yes", -- sets vim.opt.signcolumn to yes
          wrap = false, -- sets vim.opt.wrap
          conceallevel = 2, -- sets vim.opt.conceallevel
          sessionoptions = sessionoptions, -- sets vim.opt.sessionoptions
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map

          -- navigate buffer tabs
          ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          -- mappings seen under group name "Buffer"
          ["<Leader>bd"] = {
            function()
              require("astroui.status.heirline").buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Close buffer from tabline",
          },

          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          -- ["<Leader>b"] = { desc = "Buffers" },

          -- setting a mapping to false will disable it
          -- ["<C-S>"] = false,

          ["<Leader>?"] = {
            function()
              require("which-key").show { global = false } -- Show the which-key popup for local keybindings
            end,
            desc = "Show Local Keybindings",
          },

          ["<Leader>m"] = { desc = " Markdown" },
          ["<Leader>mf"] = { desc = "Fold" },
          ["<Leader>mh"] = { desc = "Headings increase/decrease" },
          ["<Leader>ml"] = { desc = "Links" },
          ----- SPELL -----
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
          ----- OBSIDIAN -----
          ["<Leader>mo"] = { desc = "Obsidian" },
          ["<Leader>moc"] = { "<cmd>ObsidianCheck<CR>", desc = "Obsidian Check Checkbox" },
          ["<Leader>mot"] = { "<cmd>ObsidianTemplate<CR>", desc = "Insert Obsidian Template" },
          ["<Leader>moo"] = { "<cmd>Obsidian Open<CR>", desc = "Open in Obsidian App" },
          ["<Leader>mob"] = { "<cmd>ObsidianBacklinks<CR>", desc = "Show ObsidianBacklinks" },
          ["<Leader>mol"] = { "<cmd>ObsidianLinks<CR>", desc = "Show ObsidianLinks" },
          ["<Leader>mon"] = { "<cmd>ObsidianNew<CR>", desc = "Create New Note" },
          ["<Leader>mos"] = { "<cmd>ObsidianSearch<CR>", desc = "Search Obsidian" },
          ["<Leader>moq"] = { "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch" },

          ----- OIL -----
          -- ["-"] = { "<cmd>Oil<CR>", desc = "Open parent directory" },

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
    })
  end,
}
