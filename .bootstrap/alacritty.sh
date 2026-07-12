#!/bin/bash

# build from source
set -e

sudo apt install cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y

cd ~/.local/src/
rm -rf alacritty
git clone https://github.com/alacritty/alacritty.git
cd alacritty

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable

cargo build --release

mkdir -p "$HOME/.local/bin"
cp target/release/alacritty "$HOME/.local/bin/"

# override the keymaps
CMD="$HOME/.local/bin/alacritty"
KEY="<Primary><Alt>t"
PATH_ID="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom_alacritty/"
SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH_ID"

gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"

gsettings set "$SCHEMA" name 'Alacritty'
gsettings set "$SCHEMA" command "$CMD"
gsettings set "$SCHEMA" binding "$KEY"

CURRENT=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

if [[ "$CURRENT" != *"$PATH_ID"* ]]; then
    if [[ "$CURRENT" == "@as []" || "$CURRENT" == "[]" ]]; then
        NEW_LIST="['$PATH_ID']"
    else
        NEW_LIST=$(echo "$CURRENT" | sed "s|\]|, '$PATH_ID'\]|")
    fi
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
fi
