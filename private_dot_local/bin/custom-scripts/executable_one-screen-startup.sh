#!/usr/bin/env bash

# Function to switch GNOME workspaces safely
switch_workspace() {
    local index=$1
    busctl call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s \
        "Main.wm.showWorkspace(global.workspace_manager.get_workspace_by_index($index));" > /dev/null 2>&1
}

# --- STEP 1: FORCE WORKSPACE 1 FOCUS ---
# Ensure your desktop shifts to the first workspace right away
switch_workspace 0
sleep 0.3

# --- STEP 2: LAUNCH THE SINGLE FIREFOX WINDOW ---
# Start exactly ONE Firefox instance
firefox &

# --- STEP 3: WAIT AND CONFIRM ---
# Sleep to give the application enough time to fully paint the window 
# and lock system focus onto itself before the script ends.
sleep 2.5
