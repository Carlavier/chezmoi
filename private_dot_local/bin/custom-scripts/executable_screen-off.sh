#!/bin/bash
STATE_FILE="$HOME/.config/screen_layout_state"

echo "single" > "$STATE_FILE"

gdbus call --session \
    --dest org.gnome.Mutter.DisplayConfig \
    --object-path /org/gnome/Mutter/DisplayConfig \
    --method org.freedesktop.DBus.Properties.Set \
    org.gnome.Mutter.DisplayConfig PowerSaveMode "<int32 1>" >/dev/null
