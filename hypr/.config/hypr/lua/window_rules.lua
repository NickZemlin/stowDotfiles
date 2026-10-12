hl.window_rule({
	match = {
		class = "^(steam)$",
	},
	workspace = 5,
	no_initial_focus = true,
})

hl.window_rule({
	match = {
		class = "^(dota2)$",
	},
	workspace = 2,
	no_initial_focus = true,
})

hl.window_rule({
	match = {
		class = "^(org.telegram.desktop)$",
	},
	workspace = 1,
	no_initial_focus = true,
})

hl.window_rule({
	match = {
		class = "^(discord)$",
	},
	workspace = 1,
	no_initial_focus = true,
})

hl.window_rule({
	match = {
		title = "^(Hyprshot)",
	},
	float = true,
})
