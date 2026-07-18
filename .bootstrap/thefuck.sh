#!/bin/bash

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update -y
sudo apt-get install -y python3.11 python3.11-venv

pipx uninstall thefuck || true
pipx install thefuck --python python3.11
