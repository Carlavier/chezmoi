#!/bin/bash
set -e

# deps
sudo apt install build-essential fd-find nodejs npm ripgrep python3-pip python3-venv luarocks lua5.1 liblua5.1-0-dev wl-clipboard -y
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
sudo ln -sf /usr/bin/luarocks /usr/local/bin/luarocks
sudo npm install -g tree-sitter-cli neovim
pip3 install --upgrade --user --force-reinstall pynvim --break-system-packages

# download and install
mkdir -p "$HOME/.local/bin"
curl -LO https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
mv nvim-linux-x86_64.appimage "$HOME/.local/bin/nvim"

# headless sync
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export NVIM_PYTHON3_HOST_PROG="/usr/bin/python3"

"$HOME/.local/bin/nvim" --headless -e "+Lazy! sync" +qa || true
"$HOME/.local/bin/nvim" --headless -e "+Lazy! build telescope-fzf-native.nvim" +qa || true
"$HOME/.local/bin/nvim" --headless -e +"MasonInstall basedpyright clangd emmet-language-server lua-language-server vtsls" +qa || true

sudo apt install cowsay fortune
