#/bin/bash

sudo apt install gnome-shell-extension-manager
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

gsettings set org.gnome.shell.keybindings move-window-workspace-5 "['<Shift><Control><Super>5']"
gsettings set org.gnome.shell.keybindings switch-to-workspace-5 "['<Control><Super>5']"
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 5

gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 2
