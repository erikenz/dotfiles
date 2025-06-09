-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  --- Recipes
  { import = "astrocommunity.recipes.picker-lsp-mappings" },

  --- Theme and colors
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- color picker and highlighter
  { import = "astrocommunity.color.ccc-nvim" },

  --- Editor
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.motion.mini-surround" },

  --- Packs
  { import = "astrocommunity.pack.biome" },
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript" },

  --- Snacks
  { import = "astrocommunity.fuzzy-finder.snacks-picker" },
  { import = "astrocommunity.indent.snacks-indent-hlchunk" },

  --- IA
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.completion.copilot-vim-cmp" },
  { import = "astrocommunity.editing-support.copilotchat-nvim" },

  --- Note taking
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },

  --- Scrolling and animations
  -- { import = "astrocommunity.scrolling.mini-animate" },
  -- { import = "astrocommunity.scrolling.neoscroll-nvim" },

  --- Debugging
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  --- Extra
  { import = "astrocommunity.workflow.precognition-nvim" },
  -- { import = "astrocommunity.indent.mini-indentscope" },
  { import = "astrocommunity.icon.mini-icons" },
  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },
  -- { import = "astrocommunity.game.leetcode-nvim"}
}
