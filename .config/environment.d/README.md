Files placed in this folder (or at least, the ones with a `.conf` extension) are read by systemd when I log in through GDM. (I thought it was just for Wayland but it seems to be for Xorg too.)

The files here aren't *sourced* by GDM, but they do use a bash-like syntax that supports ${FOO:-default-value} and ${FOO:+alternate_value}. They aren't used at all for terminal/shell logins, but a code snippet like this in ~/.profile would have that effect:

```
# Get environment from ~/.config/environment.d/ files
ENVIRONMENTD="$HOME/.config/environment.d"
set -a
if [ -d "$ENVIRONMENTD" ]; then
    for conf in $(ls "$ENVIRONMENTD"/*.conf); do
        . "$conf"
    done
fi
set +a
```

For more information see:

* <https://unix.stackexchange.com/questions/317282/>
* <https://in.waw.pl/~zbyszek/blog/environmentd.html>
* <https://wiki.archlinux.org/index.php/Environment_variables>
* <https://wiki.archlinux.org/index.php/Systemd/User>

See also my `~/.pam_environment` file. I don't know if that's still needed now that the files in this directory are being picked up.
