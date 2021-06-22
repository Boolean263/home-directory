local wz = require 'wezterm'

local function home_file_exists(name)
   local f=io.open(os.getenv('HOME').."/"..name,"r")
   if f~=nil then
       io.close(f)
       return true
   else
       return false
   end
end

local my_fonts = {
    "Iosevka Fixed",
    "Source Code Pro",
    "monospace",
}

local myterm
if home_file_exists(".terminfo/w/wezterm") then
    myterm = "wezterm"
else
    -- This is the default
    myterm = "xterm-256color"
end

return {
    enable_tab_bar = false,
    enable_wayland = true,
    term = myterm,

    -- https://wezfurlong.org/wezterm/config/fonts.html
    font_size = 12.0,
    font = wz.font_with_fallback(my_fonts),
    font_antialias = "Subpixel",
    font_hinting = "Full",

    -- https://wezfurlong.org/wezterm/config/keys.html
    keys = {
        {key="Backspace", mods="CTRL", action=wz.action{SendString="\x08"}},
    },

    -- https://wezfurlong.org/wezterm/config/appearance.html
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

    set_environment_variables = {
        COLORTERM="truecolor",
    },
}
