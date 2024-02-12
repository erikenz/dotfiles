-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
if vim.g.vscode then
	print("Loaded VSCode settings")
	require("custom.vscode")
	-- print("keymaps: ", dump(vim.keymap))
	-- print("test")
else
	print("Loaded Neovim settings")
end

-- Function to add mappings to the table
-- local function add_mappings(mode)
-- 	local result = vim.api.nvim_get_keymap(mode)
-- 	for _, mapping in ipairs(result) do
-- 		table.insert(nvimMappings, {
-- 			mode = mapping.mode,
-- 			keys = mapping.lhs,
-- 			command = mapping.rhs,
-- 			buffer = mapping.buffer,
-- 			expr = mapping.expr,
-- 		})
-- 		table.insert(vscodeMappings, {
-- 			type = "command",
-- 			key = mapping.lhs,
-- 			command = "vscode.neovim-send",
-- 			buffer = mapping.buffer,
-- 			expr = mapping.expr,
-- 		})
-- 	end
-- end

-- Iterate over modes
-- local modes = { "n", "v", "x", "s", "o", "i", "c" }
-- for _, mode in ipairs(modes) do
-- 	add_mappings(mode)
-- end

-- Print the mappings
-- for _, mapping in ipairs(nvimMappings) do
-- 	print(string.format("Mode: %s, Keys: %s, Command: %s", mapping.mode, mapping.keys,
-- 		mapping.command))
-- end
