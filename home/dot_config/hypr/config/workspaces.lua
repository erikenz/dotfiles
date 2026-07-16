-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- No persistent rules — allow free movement between monitors

-- Primary monitor (eDP-1) defaults
hl.workspace_rule({ workspace = "3",  monitor = MONITOR1, default = true })  -- Zed
hl.workspace_rule({ workspace = "4",  monitor = MONITOR1, default = true })  -- Chromium Debug
hl.workspace_rule({ workspace = "5",  monitor = MONITOR1, default = true })  -- Ferdium
hl.workspace_rule({ workspace = "10", monitor = MONITOR1, default = true })  -- Steam

-- Secondary monitor (HDMI-A-1) defaults
hl.workspace_rule({ workspace = "8",  monitor = MONITOR2, default = true })  -- YouTube Music
hl.workspace_rule({ workspace = "9",  monitor = MONITOR2, default = true })  -- Discord/Vesktop
