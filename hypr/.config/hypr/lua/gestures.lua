hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
	scale = 0.4,
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "scroll_move",
})

hl.gesture({
	fingers = 4,
	direction = "swipe",
	action = "move",
})

hl.gesture({
	fingers = 4,
	direction = "swipe",
	action = "resize",
	mods = "SUPER",
})
