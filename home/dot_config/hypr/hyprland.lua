-- Clear package cache to allow dynamic reloading of config files on save
for k, _ in pairs(package.loaded) do
    if k:match("^config") then
        package.loaded[k] = nil
    end
end

require("config.animations")
require("config.autostart")
require("config.colors")
require("config.decorations")
require("config.defaults")
require("config.environment")
require("config.input")
require("config.keybinds")
require("config.misc")
require("config.monitors")
require("config.windowrules")
require("config.noctalia-colors")
