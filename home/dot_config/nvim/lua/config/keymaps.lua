-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({
  -- {
  --   mode = { "n" },
  --   { "<leader>t", group = "[P]todo" },
  -- },
  {
    mode = { "n", "v" },
    { "<leader>m", group = "markdown" },
    { "<leader>mf", group = "fold" },
    { "<leader>mh", group = "headings increase/decrease" },
    { "<leader>ml", group = "links" },
    { "<leader>mS", group = "spell" },
    { "<leader>mSl", group = "language" },
  },
})

----- OBSIDIAN -----
vim.keymap.set("n", "<leader>mc", "<cmd>ObsidianCheck<CR>", { desc = "Obsidian Check Checkbox" })
vim.keymap.set("n", "<leader>mt", "<cmd>Obsidian template<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>mT", "<cmd>Obsidian new_from_template<CR>", { desc = "Create from Obsidian Template" })
vim.keymap.set("n", "<leader>mo", "<cmd>Obsidian Open<CR>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>mb", "<cmd>ObsidianBacklinks<CR>", { desc = "Show ObsidianBacklinks" })
vim.keymap.set("n", "<leader>ml", "<cmd>ObsidianLinks<CR>", { desc = "Show ObsidianLinks" })
vim.keymap.set("n", "<leader>mn", "<cmd>ObsidianNew<CR>", { desc = "Create New Note" })
vim.keymap.set("n", "<leader>ms", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>mq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick Switch" })
----- MARKDOWN SPELL -----
local function toggle_spelllang(lang)
  local langs = vim.opt.spelllang:get()
  local found = false

  for i, l in ipairs(langs) do
    if l == lang then
      table.remove(langs, i)
      found = true
      break
    end
  end

  if not found then
    table.insert(langs, lang)
  end

  vim.opt.spelllang = langs
  vim.cmd("echo 'Spell languages: " .. table.concat(langs, ", ") .. "'")
end
vim.keymap.set("n", "<leader>mSle", function()
  -- vim.opt.spelllang = "en"
  -- vim.cmd("echo 'Spell language set to English'")
  toggle_spelllang("en")
end, { desc = "Toggle spelling language English" })
vim.keymap.set("n", "<leader>mSls", function()
  -- vim.opt.spelllang = "es"
  -- vim.cmd("echo 'Spell language set to Spanish'")
  toggle_spelllang("es")
end, { desc = "Toggle spelling language Spanish" })
vim.keymap.set("n", "<leader>mSlg", function()
  -- vim.opt.spelllang = "de"
  -- vim.cmd("echo 'Spell language set to German'")
  toggle_spelllang("de")
end, { desc = "Toggle spelling language German" })

-- Show spelling suggestions / spell suggestions
-- NOTE: I changed this to accept the first spelling suggestion
vim.keymap.set("n", "<leader>mSs", function()
  -- Simulate pressing "z=" with "m" option using feedkeys
  -- vim.api.nvim_replace_termcodes ensures "z=" is correctly interpreted
  -- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
  -- If {mode} is absent, keys are remapped.
  --
  -- I tried this keymap as usually with
  vim.cmd("normal! 1z=")
  -- But didn't work, only with nvim_feedkeys
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
end, { desc = "Spelling suggestions" })

-- markdown good, accept spell suggestion
-- Add word under the cursor as a good word
vim.keymap.set("n", "<leader>mSg", function()
  vim.cmd("normal! zg")
  -- I do a write so that harper is updated
  vim.cmd("silent write")
end, { desc = "Spelling add word to spellfile" })

-- Undo zw, remove the word from the entry in 'spellfile'.
vim.keymap.set("n", "<leader>mSu", function()
  vim.cmd("normal! zug")
end, { desc = "Spelling undo, remove word from list" })

-- Repeat the replacement done by |z=| for all matches with the replaced word
-- in the current window.
vim.keymap.set("n", "<leader>mSr", function()
  -- vim.cmd(":spellr")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "Spelling repeat" })
