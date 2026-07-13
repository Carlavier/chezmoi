#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y git meson ninja-build pkg-config libglib2.0-bin libglib2.0-dev libmutter-14-dev firefox tmux alacritty

BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

git clone https://github.com/jadahl/gnome-monitor-config.git
cd gnome-monitor-config
meson setup build
ninja -C build
sudo ninja -C build install

cd ~
rm -rf "$BUILD_DIR"
