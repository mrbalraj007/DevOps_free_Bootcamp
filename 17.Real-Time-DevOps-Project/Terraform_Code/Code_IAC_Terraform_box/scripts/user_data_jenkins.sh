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

# Change hostname to 'ansible-svr'
sudo hostnamectl set-hostname Jenkins-svr

# Create user 'ansadmin'
if ! id "ansadmin" &>/dev/null; then
    sudo useradd -m -s /bin/bash ansadmin
    echo "ansadmin:password" | sudo chpasswd
    echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansadmin
else
    echo "User 'ansadmin' already exists."
fi

# Enable password-based SSH login by uncommenting 'PasswordAuthentication' and setting it to 'yes'
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service
if systemctl list-units --type=service | grep -q "ssh.service"; then
    sudo systemctl restart ssh
else
    echo "SSH service not found. Please check your SSH installation."
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

# Install Jenkins
print_message "Installing Jenkins"
if ! dpkg -s jenkins >/dev/null 2>&1; then
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
else
    echo "Jenkins is already installed and running."
fi

# Install Docker
print_message "Installing Docker"
install_package "docker.io"

# Configure Docker permissions
print_message "Configuring Docker permissions"
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER || echo "User '$USER' is already in the 'docker' group."

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

# Install Git
print_message "Installing Git"
install_package "git"

# Install Maven
print_message "Installing Maven"
install_package "maven"

# Install necessary dependencies
print_message "Installing necessary dependencies"
sudo apt update -y
sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip wget lsb-release

# Install Trivy
print_message "Installing Trivy"
if ! command_exists trivy; then
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install -y trivy
else
    echo "Trivy is already installed."
fi

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
