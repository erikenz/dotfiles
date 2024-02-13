---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },

		--  format with conform
		["<leader>fm"] = {
			function()
				require("conform").format()
			end,
			"formatting",
		},

	},
	v = {
		[">"] = { ">gv", "indent" },
	},
}

if vim.g.vscode then
	print("Loaded VSCode keybinds")
	local vscode = require("vscode-neovim")
	M.vscode = {
		n = {
			["<C-n>"] = {
				function()
					vscode.action("workbench.action.toggleSidebarVisibility")
				end,
				"Toggle explorer"
			},
			["<leader>"] = {
				function()
					vscode.action("whichkey.show")
					vscode.action("whichkey.triggerKey", { args = { "n" } })
					-- vscode.action("whichkey.triggerKey", { args = { " " } })
				end,
			},
			["<leader>e"] = {
				function()
					vscode.action("workbench.action.toggleSidebarVisibility")
				end,
				"Focus explorer"
			}
		}
	}
end

-- more keybinds!

return M
