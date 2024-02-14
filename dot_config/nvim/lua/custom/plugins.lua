local overrides = require("custom.configs.overrides")
local vscode = vim.g.vscode

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		-- event = "BufWritePre"
		config = function()
			require "custom.configs.conform"
		end,
	},

	-- To make a plugin not be loaded
	--? Don't load for vscode
	{
		"NvChad/nvim-colorizer.lua",
		enabled = not vscode
	},
	{
		"NvChad/ui",
		enabled = not vscode
	},
	{
		"nvim-tree/nvim-web-devicons",
		enabled = not vscode
	}

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
