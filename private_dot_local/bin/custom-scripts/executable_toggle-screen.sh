#!/bin/bash
STATE_FILE="$HOME/.config/screen_layout_state"

CURRENT_POWER=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.freedesktop.DBus.Properties.Get org.gnome.Mutter.DisplayConfig PowerSaveMode | grep -oE "[0-9]+")

if [ "$CURRENT_POWER" -ne 0 ]; then
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.freedesktop.DBus.Properties.Set org.gnome.Mutter.DisplayConfig PowerSaveMode "<int32 0>" >/dev/null
fi

STATE=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.GetCurrentState)
SERIAL=$(echo "$STATE" | grep -oE "uint32 [0-9]+" | head -n1 | awk '{print $2}')

if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" = "dual" ]; then
    echo "single" > "$STATE_FILE"
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig "$SERIAL" 1 "[(0, 0, 1.0, 0, true, [('HDMI-1', '1920x1080@100.000', [])])]" "{}" >/dev/null
else
    echo "dual" > "$STATE_FILE"
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig "$SERIAL" 1 "[(0, 0, 1.0, 0, true, [('HDMI-1', '1920x1080@100.000', [])]), (1920, 0, 1.0, 0, false, [('DP-2', '1920x1080@99.650', [])])]" "{}" >/dev/null
fi
