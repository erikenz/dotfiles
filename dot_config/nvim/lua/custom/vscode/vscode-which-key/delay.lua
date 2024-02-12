local vscode = require("vscode-neovim")
--- Set the whichkey menu sort order
--- @param time number Menu delay in milliseconds
--- @param opts? Opts The options
--- @return nil
local function delay(time, opts)
	opts = opts or {
		target = "workspace",
	}
	vscode.update_config({ "whichkey.delay" }, { time }, opts.target)
end

return delay
