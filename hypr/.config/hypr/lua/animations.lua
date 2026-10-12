-- Bezier curves
hl.curve("ease", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 3.0,
    bezier = "ease",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3.5,
    bezier = "ease",
})
hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 3.5,
    bezier = "ease",
    style = "slidevert",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 3.5,
    bezier = "ease",
    style = "slidevert",
})
