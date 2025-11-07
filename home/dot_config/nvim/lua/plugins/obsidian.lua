return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  enabled = function()
    -- Disable Obsidian when running from Oil Simple (to avoid path issues in Zed context)
    return not vim.g.disable_obsidian
  end,
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "Obsidian Vault",
        path = "~/Documents/Obsidian Vault",
      },
    },
    completition = {
      cmp = true,
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "snacks.pick",
    },
    -- Optional, define your own callbacks to further customize behavior.
    callbacks = {
      -- Runs anytime you enter the buffer for a note.
      enter_note = function(client, note)
        -- Setup keymaps for obsidian notes
        vim.keymap.set("n", "gf", function()
          return require("obsidian").util.gf_passthrough()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian follow link" })

        vim.keymap.set("n", "<leader>ch", function()
          return require("obsidian").util.toggle_checkbox()
        end, { buffer = note.bufnr, desc = "Toggle checkbox" })

        vim.keymap.set("n", "<cr>", function()
          return require("obsidian").util.smart_action()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian smart action" })
      end,
    },
    new_notes_location = "notes_subdir",
    -- Where obsidian templates & daily notes live relative to vault root
    templates = {
      subdir = "templates", -- folder inside vault with templates
      date_format = "%Y-%m-%d", -- for dailies if templates use dates
      gtime_format = "%H:%M", -- Time format for templates
      tags = "", -- Default tags for templates
      customizations = {
        ["zettel.md"] = {
          -- create the new note under <VAULT_ROOT>/Resources/Zettelkasten
          notes_subdir = "resources/zettelkasten",

          -- produce filenames like: 202510301200-brief-title.md
          note_id_func = function(title, _path)
            local function slugify(s)
              if not s then
                return ""
              end
              s = s:lower()
              -- replace non-alnum with '-', strip leading/trailing '-'
              s = s:gsub("[^a-z0-9]+", "-"):gsub("^-+", ""):gsub("-+$", "")
              return s
            end

            local ts = os.date("%Y%m%d%H%M")
            if title and title ~= "" then
              return ts .. "-" .. slugify(title)
            end
            return ts
          end,
        },
        -- Project README: put under Projects/<project-slug> by default (notes_subdir creates Projects/; the template should include its own folder)
        ["project-readme.md"] = {
          notes_subdir = "projects",
          note_id_func = function(title, _path)
            local function slugify(s)
              if not s then
                return "project"
              end
              s = s:lower()
              s = s:gsub("[^a-z0-9]+", "-"):gsub("^-+", ""):gsub("-+$", "")
              return s
            end
            local ts = os.date("%Y%m%d")
            if title and title ~= "" then
              return slug .. "-" .. slugify(title)
            end
            return "project-" .. ts
          end,
        },

        -- German vocab: place in Areas/German/vocab and basic timestamp filename
        ["german-vocab.md"] = {
          notes_subdir = "areas/german/vocab",
          note_id_func = function(title, _path)
            local ts = os.date("%Y%m%d%H%M")
            return ts
          end,
        },
      },
    },

    -- Daily notes config (this maps to obsidian daily note behavior)
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = "daily.md", -- template filename inside Templates/
      workdays_only = false,
    },
  },
}
