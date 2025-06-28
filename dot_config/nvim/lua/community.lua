-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  -- Theme
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- Color
  { import = "astrocommunity.color.twilight-nvim" },
  { import = "astrocommunity.color.ccc-nvim" },
  -- Comment
  { import = "astrocommunity.comment.ts-comments-nvim" },
  -- Completion
  -- { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.completion.copilot-vim-cmp" },
  -- Debugging
  -- { import = "astrocommunity.debugging.nvim-chainsaw" },
  -- Diagnostics
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  -- Editing support
  { import = "astrocommunity.editing-support.copilotchat-nvim" },
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  -- File explorer
  -- { import = "astrocommunity.file-explorer.oil-nvim" },
  -- Git
  { import = "astrocommunity.git.mini-diff" },
  -- Keybinding
  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },
  -- Markdown and latex
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- Motion
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.motion.harpoon" },
  -- Note taking
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  -- Packs
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.biome" },
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  -- Terminal integration
  { import = "astrocommunity.terminal-integration.vim-tmux-navigator" },
  -- Utility
  { import = "astrocommunity.utility.nvim-toggler" },
  -- { import = "astrocommunity.utility.hover-nvim" },
  -- Workflow
  { import = "astrocommunity.workflow.precognition-nvim" },
}
