#!/bin/bash
set -e

SCRIPT_PATH="$HOME/.local/bin/custom-scripts/toggle-screen.sh"
PATH_ID="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom_toggle_screen/"
SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH_ID"

gsettings set org.gnome.mutter.keybindings switch-monitor "['']"

gsettings set "$SCHEMA" name 'Toggle DP-2 Screen'
gsettings set "$SCHEMA" command "$SCRIPT_PATH"
gsettings set "$SCHEMA" binding "<Super>p"

CURRENT=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

if [[ "$CURRENT" != *"$PATH_ID"* ]]; then
    if [[ "$CURRENT" == "@as []" || "$CURRENT" == "[]" ]]; then
        NEW_LIST="['$PATH_ID']"
    else
        NEW_LIST=$(echo "$CURRENT" | sed "s|\]|, '$PATH_ID'\]|")
    fi
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
fi
