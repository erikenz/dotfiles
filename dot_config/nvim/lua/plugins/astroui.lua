-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Cached language mappings
local lang_map = {
  en_us = "EN",
  es_mx = "ES",
  de = "DE",
}
local function get_spell_status()
  local result = {}
  for lang in vim.bo.spelllang:gmatch "[^,]+" do
    table.insert(result, lang_map[lang] or lang)
  end
  return table.concat(result, ",")
end
local function should_show_spell_status() return vim.bo.filetype == "markdown" and vim.wo.spell end

---@type LazySpec
return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "catppuccin-mocha",
      -- colorscheme = "astrodark",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      highlights = {
        init = { -- this table overrides highlights in all themes
          -- Normal = { bg = "#000000" },
        },
        astrodark = { -- a table of overrides/changes when applying the astrotheme theme
          -- Normal = { bg = "#000000" },
        },
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
        Language = "",
        Clock = "", -- add icon for clock
      },
      status = {
        attributes = {
          language = {
            bold = true,
            -- underline = true,
            fg = "#ff9e64", -- color for the language component
          },
        },
      },
    },
  },
  -- Plugin: nvim-docs-view
  -- URL: https://github.com/amrbashir/nvim-docs-view
  -- Description: A Neovim plugin for viewing documentation.
  {
    "amrbashir/nvim-docs-view",
    lazy = true, -- Load this plugin lazily
    cmd = "DocsViewToggle", -- Command to toggle the documentation view
    opts = {
      position = "right", -- Position the documentation view on the right
      width = 60, -- Set the width of the documentation view
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = { border = "single" },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- Create a custom component to display the time
      local component = status.component.builder {
        {
          provider = function()
            local lang = get_spell_status() -- get the current spell language
            return status.utils.stylize(lang, {
              icon = { kind = "Language", padding = { right = 1 } }, -- use our new clock icon
              padding = { right = 0, left = 1 }, -- pad the right side so it's not cramped
            })
          end,
        },
        hl = status.hl.get_attributes("language", true),
        -- hl = status.hl.get_attributes "mode", -- highlight based on mode attributes
        -- surround = { separator = "right" },
        -- surround = { separator = "right", color = status.hl.mode_bg }, -- background highlight based on mode
        condition = should_show_spell_status,
      }
      table.insert(opts.statusline, 11, component)
    end,
  },
}
