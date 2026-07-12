#!/bin/bash
STATE_FILE="$HOME/.config/dp2_state"
STATE=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.GetCurrentState)
SERIAL=$(echo "$STATE" | grep -oE "uint32 [0-9]+" | head -n1 | awk '{print $2}')

if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" = "on" ]; then
    echo "off" > "$STATE_FILE"
    # HDMI-1 only: Positioned at (0, 0)
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig "$SERIAL" 1 "[(0, 0, 1.0, 0, true, [('HDMI-1', '1920x1080@100.000', [])])]" "{}" >/dev/null
else
    echo "on" > "$STATE_FILE"
    # HDMI-1 on Left at (0, 0) [Primary] | DP-2 on Right at (1920, 0) [Secondary]
    gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.ApplyMonitorsConfig "$SERIAL" 1 "[(0, 0, 1.0, 0, true, [('HDMI-1', '1920x1080@100.000', [])]), (1920, 0, 1.0, 0, false, [('DP-2', '1920x1080@99.650', [])])]" "{}" >/dev/null
fi
