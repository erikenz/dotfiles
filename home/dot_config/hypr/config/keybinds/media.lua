-- Media & Hardware Controls Keybindings
local noctCall = "qs -c noctalia-shell ipc call "

-- Audio (Physical Keys)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume increase"),
    { locked = true, repeating = true, desc = "Increase speaker volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume decrease"),
    { locked = true, repeating = true, desc = "Decrease speaker volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume muteOutput"),
    { locked = true, desc = "Toggle mute output" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "volume muteInput"),
    { locked = true, desc = "Toggle mute microphone" })

-- Audio (Normal Keyboard Shortcuts)
local mainMod = "SUPER"
hl.bind(mainMod .. " + CONTROL + equal", hl.dsp.exec_cmd(noctCall .. "volume increase"),
    { locked = true, repeating = true, desc = "Increase speaker volume (Keyboard)" })
hl.bind(mainMod .. " + CONTROL + minus", hl.dsp.exec_cmd(noctCall .. "volume decrease"),
    { locked = true, repeating = true, desc = "Decrease speaker volume (Keyboard)" })

-- Media Playback (Physical Keys)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media playPause"),
    { locked = true, desc = "Play/Pause media playback" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media playPause"),
    { locked = true, desc = "Play/Pause media playback" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), { locked = true, desc = "Play next media track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"),
    { locked = true, desc = "Play previous media track" })

-- Media Playback (Normal Keyboard Shortcuts)
hl.bind(mainMod .. " + CONTROL + backslash", hl.dsp.exec_cmd(noctCall .. "media playPause"),
    { locked = true, desc = "Play/Pause media playback (Keyboard)" })
hl.bind(mainMod .. " + CONTROL + SHIFT + equal", hl.dsp.exec_cmd(noctCall .. "media next"),
    { locked = true, desc = "Play next media track (Keyboard)" })
hl.bind(mainMod .. " + CONTROL + SHIFT + minus", hl.dsp.exec_cmd(noctCall .. "media previous"),
    { locked = true, desc = "Play previous media track (Keyboard)" })

-- Screen Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctCall .. "brightness increase"),
    { repeating = true, locked = true, desc = "Increase monitor brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness decrease"),
    { repeating = true, locked = true, desc = "Decrease monitor brightness" })

-- G600 binds
hl.bind("F19", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("F23", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("F24", hl.dsp.exec_cmd("playerctl next"))
