#!/bin/bash

# plugins deps
sudo apt install build-essential fd-find nodejs npm ripgrep python3-pip python3-venv -y
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
sudo npm install -g tree-sitter-cli neovim

# setups
mkdir -p "$HOME/.local/bin"
curl -LO https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
mv nvim-linux-x86_64.appimage "$HOME/.local/bin/nvim"

# headless sync & build
"$HOME/.local/bin/nvim" --headless -e "+Lazy! sync" +qa
"$HOME/.local/bin/nvim" --headless -e "+Lazy! build telescope-fzf-native.nvim" +qa
"$HOME/.local/bin/nvim" --headless -e +"MasonInstall basedpyright clangd emmet-language-server lua-language-server vtsls" +qa
