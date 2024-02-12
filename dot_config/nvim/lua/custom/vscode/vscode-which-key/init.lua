--? Lua Annotationjerginureginuerfquinebrfnuibefinubefniups:
-- https://luals.github.io/wiki/annotations

local vscode = require("vscode-neovim")

---@class Opts
---@field target? "global" | "workspace" The target to register the mappings to, either "global" or "workspace"
---@field leader? string The leader key to use, defaults to " " (space)

local M = {}
M.register = require("custom.vscode.vscode-which-key.register")
M.sortOrder = require("custom.vscode.vscode-which-key.sortOrder")
M.delay = require("custom.vscode.vscode-which-key.delay")

return M
