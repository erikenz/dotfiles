local vscode = require("vscode-neovim")

--- Set the whichkey menu sort order
--- @param order "none"|"custom"|"customNonNumberFirst"|"typeThenCustom"|"alphabetically"|"nonNumberFirst" Sort order
--- @param opts? Opts The options
--- @return nil
local function sortOrder(order, opts)
	if (order ~= 'none') and (order ~= 'custom') and (order ~= 'customNonNumberFirst') and (order ~= 'typeThenCustom') and (order ~= 'alphabetically') and (order ~= 'nonNumberFirst') then
		return error("Invalid sortOrder, '" ..
			order ..
			"' is not assignable to 'none' | 'custom' | 'customNonNumberFirst' | 'typeThenCustom' | 'alphabetically' | 'nonNumberFirst'")
	end
	opts = opts or {
		target = "global",
	}
	vscode.update_config({ "whichkey.sortOrder" }, { order }, opts.target)
end

return sortOrder
