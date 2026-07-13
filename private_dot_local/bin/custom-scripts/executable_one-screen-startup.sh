#!/bin/bash

sleep 5

busctl --user set-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode i 0
gnome-monitor-config set -LpM HDMI-1 -m 1920x1080@100.000
