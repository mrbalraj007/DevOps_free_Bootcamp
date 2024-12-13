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

# Generate SSH key for ansadmin user
print_message "Generating SSH key for 'ansadmin' user"
sudo -u ansadmin bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
if [ ! -f /home/ansadmin/.ssh/id_rsa ]; then
    sudo -u ansadmin ssh-keygen -t rsa -b 2048 -f /home/ansadmin/.ssh/id_rsa -N ""
    echo "SSH key generated for 'ansadmin' user."
else
    echo "SSH key already exists for 'ansadmin' user."
fi

# Install Ansible
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

# Confirm Ansible installation

echo "To show Ansible Version..."

ansible --version

# Install Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc  # Remove any old Docker versions
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker and enable it to run on startup
sudo systemctl start docker
sudo systemctl enable docker

# Add 'ansadmin' to the Docker group to allow Docker usage without sudo
# sudo chown ansadmin /var/run/docker.sock
# sudo chown ansadmin /var/run/docker.sock
sudo usermod -aG docker ansadmin && newgrp docker
sudo usermod -aG docker dockeradmin && newgrp docker
# sudo chown $USER /var/run/docker.sock
# sudo chown ansadmin /var/run/docker.sock
# sudo usermod -aG docker ansadmin
# sudo usermod -aG docker $USER
# sudo usermod -aG docker $USER && newgrp docker

# Confirm Docker installation
echo "To show version Version..."
docker --version