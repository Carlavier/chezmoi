#!/bin/bash

if ! grep -qF ".bashrc-custom" ~/.bashrc; then
    cat << 'EOF' >> ~/.bashrc

if [ -f ~/.bashrc-custom ]; then
    . ~/.bashrc-custom
fi
EOF
fi

source ~/.bashrc
