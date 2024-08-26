#!/bin/bash

# To Turning off Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
sudo systemctl reload ssh

# Set Root password
echo "[TASK 2] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1

sudo apt-get update 
sudo apt-get install -y curl net-tools
sudo apt-get install -y keepalived haproxy

# Install or update the AWS CLI
sudo apt install unzip curl -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Clean Up: Optionally, you can remove the downloaded files to clean up your directory.
rm awscliv2.zip
rm -rf aws
