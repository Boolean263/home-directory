-- This file is read by devilspie2 to determine which window events
-- should trigger which scripts.

-- Any scripts that exist in the current directory but are not mentioned
-- here are executed on window open.

-- Run when a window closes (note, many window properties are missing)
scripts_window_close = {
    "debug_close.lua",
}

-- Run when a window gains focus
scripts_window_focus = {
    "debug_focus.lua",
}

-- Run when a window loses focus
scripts_window_blur = {
    "debug_blur.lua",
}

-- Any functions or other variables defined in this file are available
-- to all your other scripts.

dap_debug = function(evt_name)
    local dprintf = function(s, ...)
        return debug_print(s:format(...))
    end

    local fmt_str = '%-20s: %s'

    dprintf('---------- %s ----------', evt_name)
    dprintf(fmt_str, 'Window XID:', get_window_xid())
    dprintf(fmt_str, 'Window Name:', get_window_name())
    dprintf(fmt_str, 'Window Type:', get_window_type())
    dprintf(fmt_str, 'Window Role:', get_window_role())
    dprintf(fmt_str, 'Application Name:', get_application_name())
end
