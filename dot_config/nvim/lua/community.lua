-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.comment.ts-comments-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  -- { import = "astrocommunity.diagnostics.error-lens-nvim" },
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.mini-operators" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.utility.hover-nvim" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.mini-bracketed" },
  { import = "astrocommunity.git.gitgraph-nvim" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.workflow.hardtime-nvim" },
  -- import/override with your plugins folder
}
