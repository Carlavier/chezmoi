#!/bin/bash

STATE=$(gnome-monitor-config list)

if echo "$STATE" | grep -Fq "Monitor [ DP-2 ] ON"; then
    gnome-monitor-config set -LpM HDMI-1 -m 1920x1080@100.000
else
    gnome-monitor-config set -LpM HDMI-1 -m 1920x1080@100.000 -LM DP-2 -m 1920x1080@99.650 -x 1920
fi
