local vwk = require("custom.vscode.vscode-which-key")
local Mappings = require("core.mappings")

vwk.register(Mappings, { target = "global" })
vwk.sortOrder("none", { target = "global" })
vwk.delay(500, { target = "global" })
