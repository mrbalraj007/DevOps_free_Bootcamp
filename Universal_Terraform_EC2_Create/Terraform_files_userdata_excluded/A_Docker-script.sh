#!/bin/bash

sudo -i

# Define the new hostname
NEW_HOSTNAME="ansible"

# Set the new hostname
sudo hostnamectl set-hostname $NEW_HOSTNAME

# Restart the systemd-logind service
sudo systemctl restart systemd-logind.service

# Print the new hostname
echo "The hostname has been changed to: $NEW_HOSTNAME"

# Append configurations to /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Restart SSH service and reload daemon
systemctl restart sshd
systemctl daemon-reload

# Update the package repository and install prerequisites
sudo yum update -y

# Install Java
sudo sudo yum install java-17-amazon-corretto tmux -y

# To install Ansible.
sudo amazon-linux-extras install epel -y
sudo yum install -y ansible

# Install Docker
sudo amazon-linux-extras install docker -y

sudo yum update -y

# # Add the current user to the docker group
# sudo chown $USER /var/run/docker.sock
# sudo usermod -aG docker $USER

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Add your user to the docker group
sudo usermod -aG docker $USER
# Apply the new group membership
newgrp docker

# Clean up
sudo yum clean