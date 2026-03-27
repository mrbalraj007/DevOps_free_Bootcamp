#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Pipelines return the exit status of the last command to exit with a non-zero status

# Function to print messages with separators
print_message() {
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

# Set hostname to 'sonarqube-svr'
print_message "Setting hostname to 'sonarqube-svr'"
sudo hostnamectl set-hostname sonarqube-svr


# Create user 'ansadmin' if it doesn't already exist
if ! id "ansadmin" &>/dev/null; then
    print_message "Creating user 'ansadmin'"
    sudo useradd -m -s /bin/bash ansadmin
    echo "ansadmin:password" | sudo chpasswd
    echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansadmin
else
    echo "User 'ansadmin' already exists."
fi

# Enable password-based SSH login
print_message "Configuring SSH for password-based authentication"
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Generate SSH key for ansadmin user
print_message "Generating SSH key for 'ansadmin' user"
sudo -u ansadmin bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
if [ ! -f /home/ansadmin/.ssh/id_rsa ]; then
    sudo -u ansadmin ssh-keygen -t rsa -b 2048 -f /home/ansadmin/.ssh/id_rsa -N ""
    echo "SSH key generated for 'ansadmin' user."
else
    echo "SSH key already exists for 'ansadmin' user."
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package if not already installed
install_package() {
    PACKAGE_NAME=$1
    if ! dpkg -l | grep -qw "$PACKAGE_NAME"; then
        sudo apt-get install -y "$PACKAGE_NAME"
    else
        echo "$PACKAGE_NAME is already installed."
    fi
}

# Update and install OpenJDK
print_message "Updating package lists and installing OpenJDK 17"
sudo apt update -y
sudo apt install -y wget gnupg software-properties-common

# Add Adoptium GPG key and repository
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y

# Install OpenJDK 17 JRE Headless
sudo apt install -y openjdk-17-jre-headless
java --version

# Install Docker
print_message "Installing Docker"
install_package "docker.io"

# Configure Docker permissions
print_message "Configuring Docker permissions"
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER && newgrp docker || echo "User '$USER' is already in the 'docker' group."

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Install and configure SonarQube
print_message "Installing and configuring SonarQube"
if [ ! "$(docker ps -q -f name=SonarQube-Server)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=SonarQube-Server)" ]; then
        # Cleanup
        docker rm SonarQube-Server
    fi
    docker run -d --name SonarQube-Server -p 9000:9000 sonarqube:lts-community
    echo "SonarQube is being set up and may take a few minutes to become ready."
else
    echo "SonarQube container is already running."
fi

# Install necessary dependencies
print_message "Installing necessary dependencies"
sudo apt update -y
sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip wget lsb-release

# Install AWS CLI v2
print_message "Installing AWS CLI v2"
if ! command_exists aws; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    # Clean up
    rm awscliv2.zip
    rm -rf aws
else
    echo "AWS CLI is already installed."
fi