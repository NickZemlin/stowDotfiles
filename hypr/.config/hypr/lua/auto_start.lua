hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
	hl.exec_cmd('xremap --device "Nothing Headphone (1) (AVRCP)" /home/nick/.config/xremap/config.yml')
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("~/.config/tmux/bootstrap.sh")
end)
