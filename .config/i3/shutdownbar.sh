#!/bin/sh

if /bin/false ; then
i3-nagbar -f 'pango:DejaVu Sans 10' -t warning -m 'Exit i3?' \
    -b '🛑 logout' 'i3-msg exit' \
    -b '💤 Suspend' 'xscreensaver-command -lock ; systemctl suspend' \
    -b '↻ Reboot' 'systemctl reboot' \
    -b '◑ Shutdown' 'systemctl poweroff'
fi

# It amuses me that this interrupted cat<< structure is okay in sh (dash)
RESULT=$(cat <<EOT | \
    dmenu -i -fn 'pango:DejaVu Sans 10' -p 'Exit i3?' \
    -nb '#ffa800' -nf '#000000' -sb '#680a0a' -sf '#ffffff' \
    | tr -cd '[[:alpha:]]' | tr [[:upper:]] [[:lower:]])
✘ Logout
☡ Suspend
↻ Reboot
◑ Shutdown
EOT

case "$RESULT" in
    logout)
        i3-msg exit
        ;;
    suspend)
        xscreensaver-command -lock
        systemctl suspend
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
esac

