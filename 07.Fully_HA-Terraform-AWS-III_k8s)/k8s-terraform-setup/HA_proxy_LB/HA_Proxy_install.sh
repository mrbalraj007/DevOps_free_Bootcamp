#!/bin/bash

# To Turning off Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 2] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1

sudo apt-get update 
sudo apt-get install -y curl net-tools
sudo apt-get install -y keepalived haproxy

