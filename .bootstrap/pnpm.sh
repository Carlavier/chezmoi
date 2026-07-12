#!/bin/bash

if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

curl -fsSL https://get.pnpm.io/install.sh | sh -
