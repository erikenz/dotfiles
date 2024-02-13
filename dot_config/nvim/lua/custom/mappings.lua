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
	M.vscodeWhichkey = {
		n = {
			["<leader>"] = {
				function()
					vscode.action("whichkey.show")
					vscode.action("whichkey.triggerKey", { args = { "n" } })
					vscode.action("whichkey.triggerKey", { args = { " " } })
				end,
				"(whichkey-hidden) Open Whichkey"
			},
			-- ["g"] = {
			-- 	function()
			-- 		vscode.action("whichkey.show")
			-- 		vscode.action("whichkey.triggerKey", { args = { "n" } })
			-- 		vscode.action("whichkey.triggerKey", { args = { "g" } })
			-- 	end,
			-- 	"(whichkey-hidden) Goto"
			-- }
		}
	}
	M.vscode = {
		n = {
			["<C-n>"] = {
				function()
					vscode.action("workbench.action.toggleSidebarVisibility")
				end,
				"Toggle explorer"
			},
			["<leader>e"] = {
				function()
					vscode.action("workbench.view.explorer")
				end,
				"Focus explorer"
			},
			["<C-l>"] = {
				function()
					vscode.action("workbench.action.navigateRight")
				end,
				"Navigate right"
			},
			["<C-h>"] = {
				function()
					vscode.action("workbench.action.navigateLeft")
				end,
				"Navigate left"
			},
			["<C-j>"] = {
				function()
					vscode.action("workbench.action.navigateDown")
				end,
				"Navigate down"
			},
			["<C-k>"] = {
				function()
					vscode.action("workbench.action.navigateUp")
				end,
				"Navigate up"
			},
		},
		t = {
			["<C-l>"] = {
				function()
					vscode.action("workbench.action.navigateRight")
				end,
				"Navigate right"
			},
			["<C-h>"] = {
				function()
					vscode.action("workbench.action.navigateLeft")
				end,
				"Navigate left"
			},
			["<C-j>"] = {
				function()
					vscode.action("workbench.action.navigateDown")
				end,
				"Navigate down"
			},
			["<C-k>"] = {
				function()
					vscode.action("workbench.action.navigateUp")
				end,
				"Navigate up"
			},
		}
	}
end

-- more keybinds!

return M
