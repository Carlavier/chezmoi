#!/bin/bash
set -e

AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/speaker-startup.desktop"
SCRIPT_PATH="$HOME/.local/bin/custom-scripts/speaker-startup.sh"

mkdir -p "$AUTOSTART_DIR"

cat << EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=$SCRIPT_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Connect Bluetooth Speaker On Boot
Comment=Connects to the bluetooth speaker after a 10 second delay
EOF

chmod +x "$DESKTOP_FILE"
