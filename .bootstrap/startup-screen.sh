#!/bin/bash
set -e

AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/hdmi-startup.desktop"
SCRIPT_PATH="$HOME/.local/bin/custom-scripts/one-screen-startup.sh"

mkdir -p "$AUTOSTART_DIR"

cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=/bin/bash -c "$SCRIPT_PATH"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Force HDMI Only On Boot
Comment=Initializes monitor layout with only HDMI active
EOF

chmod +x "$DESKTOP_FILE"
