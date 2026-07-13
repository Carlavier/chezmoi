#!/usr/bin/env bash

killall alacritty 2>/dev/null

switch_ws() {
    local index=$1
    gdbus call --session \
        --dest org.gnome.Shell \
        --object-path /org/gnome/Shell/Extensions/WsDbus \
        --method org.gnome.Shell.Extensions.WsDbus.Switch "$index" \
        > /dev/null
}


switch_ws 0
sleep 0.2
firefox &
sleep 4.5 

switch_ws 1
sleep 0.2
firefox --private-window &
sleep 2.0 

switch_ws 2
sleep 0.2
/home/carlavier/.local/bin/alacritty -e tmux new-session -A -s main &
sleep 1.2 

switch_ws 3
sleep 0.2
firefox --new-window "https://platform.deepseek.com" &
sleep 1.5 

firefox --new-tab "https://grok.com" &
sleep 0.2
firefox --new-tab "https://gemini.google.com" &
sleep 4.0 

switch_ws 0

clear
