local M = {}


local C = {
    light_grey = "#d8d8d8",
    rosy_pink = "#d58ca6",
    soft_green = "#96ca96",
    muted_slate = "#858d95",
    bright_red = "#ef6f6f",
    pale_blue = "#adc7e6",
    muted_cyan = "#8abbb4",
    dark_navy = "#11161c",
    steel_grey = "#5a6475",
    ash_grey = "#3c4455",
    deep_blue = "#252f3d",
    dusk_blue = "#33415c",
    sand_yellow = "#d1b77a",
    aqua_teal = "#5fa6a6",
}


-- Use brighter panel blue for visibility across all modes

M.normal = {
    a = { fg = C.muted_slate, bg = C.deep_blue, gui = "bold" },
    b = { fg = C.muted_slate, bg = C.dark_navy },
    c = { fg = C.light_grey, bg = C.deep_blue },
}
M.insert = {
    a = { fg = C.soft_green, bg = C.deep_blue, gui = "bold" },
    b = { fg = C.muted_slate, bg = C.dark_navy },
    c = { fg = C.light_grey, bg = C.deep_blue },
}
M.visual = {
    a = { fg = C.rosy_pink, bg = C.deep_blue, gui = "bold" },
    b = { fg = C.muted_slate, bg = C.dark_navy },
    c = { fg = C.light_grey, bg = C.deep_blue },
}
M.replace = {
    a = { fg = C.bright_red, bg = C.deep_blue, gui = "bold" },
    b = { fg = C.muted_slate, bg = C.dark_navy },
    c = { fg = C.light_grey, bg = C.deep_blue },
}
M.command = {
    a = { fg = C.sand_yellow, bg = C.deep_blue, gui = "bold" },
    b = { fg = C.muted_slate, bg = C.dark_navy },
    c = { fg = C.light_grey, bg = C.deep_blue },
}
M.inactive = {
    a = { fg = C.steel_grey, bg = C.deep_blue },
    b = { fg = C.steel_grey, bg = C.dark_navy },
    c = { fg = C.steel_grey, bg = C.dark_navy },
}


return M
