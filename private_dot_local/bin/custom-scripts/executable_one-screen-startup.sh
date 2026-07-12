#!/bin/bash
STATE_FILE="$HOME/.config/screen_layout_state"

echo "single" > "$STATE_FILE"

sleep 5

gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.freedesktop.DBus.Properties.Set org.gnome.Mutter.DisplayConfig PowerSaveMode "<int32 0>" >/dev/null

STATE=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.GetCurrentState)
SERIAL=$(echo "$STATE" | grep -oE "uint32 [0-9]+" | head -n1 | awk '{print $2}')

if [ -n "$SERIAL" ]; then
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig "$SERIAL" 1 "[(0, 0, 1.0, 0, true, [('HDMI-1', '1920x1080@100.000', [])])]" "{}" >/dev/null
fi
