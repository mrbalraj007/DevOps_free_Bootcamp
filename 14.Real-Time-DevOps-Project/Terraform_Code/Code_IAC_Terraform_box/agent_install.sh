#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Pipelines return the exit status of the last command to exit with a non-zero status

# Function to print messages with separators
print_message() {
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

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
sudo usermod -aG docker "$USER" || echo "User '$USER' is already in the 'docker' group."

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker-Compose
sudo apt-get install docker-compose-v2

# Install necessary dependencies
print_message "Installing necessary dependencies"
sudo apt update -y
sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip wget lsb-release

# Install Terraform
print_message "Installing Terraform"
if ! command_exists terraform; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y terraform
else
    echo "Terraform is already installed."
fi

# Install kubectl
print_message "Installing kubectl"
if ! command_exists kubectl; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubectl
else
    echo "kubectl is already installed."
fi

# Install eksctl
print_message "Installing eksctl"
if ! command_exists eksctl; then
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    eksctl version
else
    echo "eksctl is already installed."
fi

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

print_message "Installation script completed successfully."
