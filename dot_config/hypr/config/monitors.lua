-- Montior wiki https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "1920x0", scale = 1 })

-- Workspace Monitor Rules
hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })

