#!/bin/bash

POWER_SAVE=$(busctl --user get-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode | awk '{print $2}')

if [ "$POWER_SAVE" -ne 0 ]; then
    busctl --user set-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode i 0
fi

STATE=$(gnome-monitor-config list)

if echo "$STATE" | grep -Fq "Monitor [ DP-2 ] ON"; then
    gnome-monitor-config set -LpM HDMI-1 -m 1920x1080@100.000
else
    gnome-monitor-config set -LpM HDMI-1 -m 1920x1080@100.000 -LM DP-2 -m 1920x1080@99.650 -x 1920
fi
