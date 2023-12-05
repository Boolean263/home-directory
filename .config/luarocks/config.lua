-- Configuration file for LuaRocks.
-- Must point LUAROCKS_CONFIG at this file for it to work.
--
-- Run `luarocks` by itself to see whether it's picked up this file.
-- Run `luarocks config` to see all configuration settings.
--
-- See: https://github.com/luarocks/luarocks/wiki/Config-file-format

home_tree = os_getenv("XDG_DATA_HOME").."/luarocks"
rocks_trees = {
    { name = "user", root = home_tree },
    { name = "system", root = "/usr/local" },
}
