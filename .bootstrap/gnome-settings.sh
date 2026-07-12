#!/bin/bash

set -e

sudo apt install -y gnome-shell-extension-manager

if ! grep -Fq 'PATH="$HOME/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/bin:$PATH" 

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    PID=$(pgrep -u "$USER" gnome-session | head -n 1)
    if [ -n "$PID" ]; then
        export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/"$PID"/environ | cut -d= -f2-)
    fi
fi

gsettings set org.gnome.shell.keybindings open-new-window-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 2
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 5
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Shift><Control><Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Control><Super>5']"
