#!/bin/bash

sudo apt update && sudo apt upgrade -y
mkdir ~/.local/src/

SCRIPTS=(
# testing
    "nvim.sh"
    "tmux.sh"
    "alacritty.sh"
    "bashrc-custom.sh"
    "openssh-server.sh"
    "tailscale.sh"
    "docker.sh"
    "pnpm.sh"
    "opencode.sh"
    "super-p-keymap.sh"
    "startup-screen.sh"
    "startup-speaker.sh"
)

SUCCESS=()
FAILED=()

for SCRIPT in "${SCRIPTS[@]}"; do
    PATH_S="$HOME/.local/share/chezmoi/.bootstrap/$SCRIPT"
    chmod +x "$PATH_S"
    
    if "$PATH_S"; then
        SUCCESS+=("$SCRIPT")
    else
        FAILED+=("$SCRIPT")
    fi
done

sudo apt autoremove -y

RED='\033[0;31m'
NC='\033[0m'

echo "--- Summary ---"
echo "Success:"
printf "%s\n" "${SUCCESS[@]}"

echo -e "\n${RED}Failed:${NC}"
printf "${RED}%s\n${NC}" "${FAILED[@]}"
