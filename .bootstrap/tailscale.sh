#!/bin/bash

curl -fsSL https://tailscale.com/install.sh | sh
if [ $? -ne 0 ]; then
    exit 1
fi

sudo systemctl daemon-reload
sudo systemctl enable --now tailscaled

sleep 2

sudo tailscale up
