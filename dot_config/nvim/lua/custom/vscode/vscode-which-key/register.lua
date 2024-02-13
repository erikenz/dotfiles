local vscode = require("vscode-neovim")
local Utils = require("custom.vscode.utils")
local M = {}

---@class BindingItem
---@field key string The key to bind
---@field name string The name of the binding
---@field command? function The command to run
---@field bindings? BindingItem[] Nested bindings
---@field mode? table<"n","v"> The mode/s to bind the command to

---Register a set of mappings
---@param mappings BindingItem[] The mappings to register.
---@param opts? Opts The options.
---@return nil
local function register(mappings, opts)
	opts = opts or {
		target = "workspace",
		leader = " ",
	}

	local whichkeyBindings = M.transformKeybinds(mappings)

	--? Update the configuration
	vscode.update_config({ "whichkey.bindings" }, { whichkeyBindings }, opts.target)
end

function M.transformKeybinds(inputTable)
	local result = {}

	for _, modes in pairs(inputTable) do
		for mode, keymaps in pairs(modes) do
			if mode ~= "plugin" then
				for keymap, actions in pairs(keymaps) do
					local shouldHide = string.find(actions[2], "(whichkey-hidden)", 1, true)
					-- print("Should hide:", keymap, shouldHide ~= nil)
					if shouldHide == nil then
						-- 	print("VSCode excluded ->", "Mode", mode, "Keymap:", keymap, "Actions:", actions[2])
						-- else
						if not result[mode] then
							result[mode] = {
								key = mode,
								name = "+" .. mode .. " mode",
								type = "bindings",
								bindings = {}
							}
						end
						local keyArray = M.getKeymapArray(keymap)
						M.insertBinding(keyArray, result[mode].bindings, {
							key = M.getVscodeKey(keyArray[#keyArray]),
							name = actions[2],
							type = "command",
							command = "vscode-neovim.send",
							args = M.getArgs(keyArray)
						})
					end
				end
			end
		end
	end
	return M.parseForVscode(result)
end

function M.parseForVscode(inputTable)
	local parsedTable = {}
	local function removeOuterKey(tbl)
		local result = {}
		for _, v in pairs(tbl) do
			if v.type == "bindings" then
				local entry = {}
				for key, value in pairs(v) do
					if key == "bindings" then
						entry[key] = removeOuterKey(value)
					else
						entry[key] = value
					end
				end
				table.insert(result, entry)
			elseif v.type == "command" then
				table.insert(result, v)
			end
		end
		return result
	end
	parsedTable = removeOuterKey(inputTable)
	return parsedTable
end

function M.insertBinding(keyPath, bindings, newTable)
	for k, value in pairs(keyPath) do
		-- if string.find(value, "<leader>") then
		-- 	print("KeyPath:", Utils.dump(keyPath), "Value:", value)
		-- end
		if k == #keyPath then
			table.insert(bindings, newTable)
		else
			if not bindings[value] then
				bindings[value] = {
					key = M.getVscodeKey(value),
					name = "+prefix",
					type = "bindings",
					bindings = {}
				}
			end
			table.remove(keyPath, 1)
			M.insertBinding(keyPath, bindings[value].bindings, newTable)
		end
	end
end

function M.getKeymapArray(keymap)
	local keyArray = {}
	local tempKeymap = keymap
	if string.match(tempKeymap, "<.->") then
		local i, j = string.find(tempKeymap, "<.->")
		if i and j then
			table.insert(keyArray, string.sub(tempKeymap, i, j))
			tempKeymap = string.sub(keymap, j + 1)
		end
	end
	for i in string.gmatch(tempKeymap, ".") do
		table.insert(keyArray, i)
	end

	return keyArray
end

function M.getVscodeKey(key)
	if key == ("<leader>") then
		return " "
	end
	if string.find(key, "tab") then
		local withouthCarets = string.sub(key, 2, #key - 1)
		return string.gsub(withouthCarets, "tab", "\t")
	end
	if string.find(key, "<.->") then
		return string.sub(key, 2, #key - 1)
	end

	return key
end

function M.getArgs(keyArray)
	local function parseKey(key)
		if key == "<leader>" then
			return " "
		end
		return key
	end
	local res = ""
	for _, value in pairs(keyArray) do
		res = res .. parseKey(value)
	end
	return res
end

return register
