#!/bin/bash

TARGET_DIR="$HOME/.local/bin/custom-scripts"

if [ -d "$TARGET_DIR" ]; then
    chmod +x "$TARGET_DIR"/* 2>/dev/null || true
fi
