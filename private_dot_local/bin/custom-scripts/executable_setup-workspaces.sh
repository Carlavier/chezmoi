#!/usr/bin/env bash

# --- PRE-REQUISITES: CLEANUP ---
killall alacritty 2>/dev/null

# Helper to handle workspace navigation via ws-dbus
switch_ws() {
    local index=$1
    gdbus call --session \
        --dest org.gnome.Shell \
        --object-path /org/gnome/Shell/Extensions/WsDbus \
        --method org.gnome.Shell.Extensions.WsDbus.Switch "$index" \
        > /dev/null
}

# --- MAIN LAYOUT EXECUTION ---

# 1. Workspace 1 (Index 0): Standard Firefox
switch_ws 0
sleep 0.2
firefox &
sleep 4.5 

# 2. Workspace 2 (Index 1): Private Firefox
switch_ws 1
sleep 0.2
firefox --private-window &
sleep 2.0 

# 3. Workspace 3 (Index 2): Alacritty Terminal with Forced Tmux Session
switch_ws 2
sleep 0.2
# Instantly runs your exact tmux configuration layout directly inside the window
/home/carlavier/.local/bin/alacritty -e tmux new-session -A -s main &
sleep 1.2 

# 4. Workspace 4 (Index 3): Heavy AI Tabs (DeepSeek -> Grok -> Gemini)
switch_ws 3
sleep 0.2
firefox --new-window "https://platform.deepseek.com" &
sleep 1.5 

firefox --new-tab "https://grok.com" &
sleep 0.2
firefox --new-tab "https://gemini.google.com" &
sleep 4.0 

# 5. Snap focus back to Workspace 1 when finished
switch_ws 0
