#!/bin/bash
# To Turning off Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

sudo apt-get update 
sudo apt-get install -y haproxy