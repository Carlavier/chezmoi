#!/bin/bash

sudo apt install -y openssh-server
sudo systemctl enable --now ssh
