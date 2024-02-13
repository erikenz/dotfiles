local Utils = require("custom.vscode.utils")
local vwk = require("custom.vscode.vscode-which-key")
local NvChadMappings = require("core.mappings")
local CustomMappings = require("custom.mappings")
local Mappings = {}

local function mergetTables(table1, table2, output)
	for k, v in pairs(table1) do
		output[k] = v
	end
	for k, v in pairs(table2) do
		output[k] = v
	end
end
mergetTables(NvChadMappings, CustomMappings, Mappings)
Utils.printf(Mappings)

vwk.register(Mappings, { target = "global" })
vwk.sortOrder("none", { target = "global" })
vwk.delay(500, { target = "global" })
