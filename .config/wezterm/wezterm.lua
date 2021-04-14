local wz = require 'wezterm'

local my_fonts = {
    "Iosevka Term",
    "Source Code Pro",
    "monospace",
}

return {
    enable_tab_bar = false,
    enable_wayland = true,

    font_size = 12.0,
    font = wz.font_with_fallback(my_fonts),
    font_antialias = "Subpixel",
    font_hinting = "Full",

    keys = {
        {key="Backspace", mods="CTRL", action=wz.action{SendString="\x08"}},
    },

    bold_brightens_ansi_colors = true,
    colors = {
        ansi = {
            '#000000',
            '#af0000',
            '#00af00',
            '#afd700',
            '#0000d7',
            '#af00af',
            '#00d7af',
            '#e0e0e0',
        },
        brights = {
            '#777777',
            '#ff0000',
            '#00ff00',
            '#ffff00',
            '#5c5cff',
            '#ff00ff',
            '#00ffff',
            '#ffffff',
        },
    },
}
