require("lua.auto_start")
require("lua.animations")
require("lua.keybinds")
require("lua.window_rules")
require("lua.layer_rules")
require("lua.monitors")
require("lua.workspace_rules")
require("lua.devices")
require("lua.gestures")

hl.config({
    decoration = {
        blur = {
            enabled = true,
            passes = 3,
            special = true,
        },
        inactive_opacity = 1,
        rounding = 0,
        shadow = {
            enabled = false,
        },
    },
    dwindle = {
        force_split = 2,
        preserve_split = true,
    },
    general = {
        layout = "scrolling",
        gaps_in = 5,
        gaps_out = { top = 20, bottom = 5, left = 5, right = 5 },
        border_size = 2,
        col = { active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 } },
        resize_on_border = false,
        allow_tearing = false,
    },
    scrolling = {
        explicit_column_widths = "0.5, 1.0",
        wrap_swapcol = false
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "us, ru",
        follow_mouse = 1,
        sensitivity = -0.4,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.35,
        },
    },
    gestures = {
        workspace_swipe_create_new = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
