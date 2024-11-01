#!/bin/bash

# Update and upgrade system packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Change hostname to 'ansible-svr'
sudo hostnamectl set-hostname ansible-svr

# Create user 'ansadmin'
sudo useradd -m -s /bin/bash ansadmin

# Set a password for 'ansadmin'
echo "ansadmin:password" | sudo chpasswd

# Add 'ansadmin' to sudoers file
echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansadmin

# Enable password-based SSH login by uncommenting 'PasswordAuthentication' and setting it to 'yes'
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Check if SSH service exists and restart it
if sudo systemctl status ssh >/dev/null 2>&1; then
    sudo systemctl restart ssh
else
    sudo systemctl restart sshd
fi

# Install Ansible
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

# Confirm Ansible installation

echo "To show Ansible Version..."

ansible --version
