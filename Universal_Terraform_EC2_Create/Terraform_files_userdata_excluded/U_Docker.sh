#!/bin/bash

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
sudo apt-get update -y

# Install Java
sudo sudo apt-get install openjdk-17-jre-headless ansible -y

# Add Docker’s official GPG key
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Update the package database with Docker packages from the newly added repo
sudo apt-get update -y


# Add Docker repository to APT sources

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add the current user to the docker group
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Clean up
sudo apt-get clean