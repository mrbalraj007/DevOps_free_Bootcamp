#!/bin/bash
sudo apt update -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
#sudo apt install temurin-17-jdk -y
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# From Officially Page
# sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update
# sudo apt-get install jenkins


##Install Docker and Run SonarQube as Container
sudo apt-get update
sudo apt-get install docker.io -y
# sudo usermod -aG docker ubuntu
# sudo usermod -aG docker jenkins  
# newgrp docker
sudo chmod 777 /var/run/docker.sock

# Add the current user to the docker group
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker


# Update system packages and install necessary dependencies
sudo apt update -y
sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform

# # Install Docker and necessary tools
# sudo apt install -y docker.io net-tools
# sudo chmod 666 /var/run/docker.sock

# # Add the current user to the Docker group
# sudo chown $USER /var/run/docker.sock
# sudo usermod -aG docker $USER

# # Enable and start Docker service
# sudo systemctl enable docker
# sudo systemctl start docker



# Install Kubernetes components (v1.31)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl


# Install EKSCTL components (0.189.0)

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version


# Download the AWS CLI Installer Download the AWS CLI version 2 installation file using curl.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the Installation File Unzip the AWS CLI installation file.
unzip awscliv2.zip

# Run the Installer Run the installer script to install AWS CLI.
sudo ./aws/install

#Verify the Installation After the installation is complete, verify that the AWS CLI was installed correctly by checking its version.
aws --version

# Clean Up: Optionally, you can remove the downloaded files to clean up your directory.
rm awscliv2.zip
rm -rf aws

echo "Starting script..."
# Perform some actions
echo "Waiting for 2 minutes before continuing..."
sleep 120  # Pause for 2 minutes
echo "Continuing with the rest of the script..."

# Create EKS Cluster
cd /home/ubuntu/k8s_setup_file
terraform init
sleep 60  # Pause for 1 minutes
terraform apply -auto-approve