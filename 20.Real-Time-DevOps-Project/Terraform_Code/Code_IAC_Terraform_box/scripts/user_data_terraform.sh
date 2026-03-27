#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Pipelines return the exit status of the last command to exit with a non-zero status

# Function to print messages with separators
print_message() {
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

# Set hostname to 'bootstrap-svr'
print_message "Setting hostname to 'bootstrap-svr'"
sudo hostnamectl set-hostname bootstrap-svr

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

# Fetch public IP address of the server
ip=$(curl -s ifconfig.me)

# Retrieve Jenkins initial admin password
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    pass=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
else
    echo "Jenkins initial admin password file not found. Ensure Jenkins is installed and started."
    exit 1
fi

# Output the URLs and credentials
echo "Access Jenkins Server here --> http://$ip:8080"
echo "Jenkins Initial Password: $pass"
echo "Access SonarQube Server here --> http://$ip:9000"
echo "SonarQube Username & Password: admin"


# Install Node.js (Version 16)
print_message "Installing Node.js"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs


echo "Starting Terraform setup..."
# Wait for 1 minute before continuing
echo "Waiting for 1 minute before continuing..."
sleep 60
echo "Continuing with Terraform setup..."

# Navigate to Terraform configuration directory and apply
cd /home/ubuntu/k8s_setup_file
terraform init

echo "alignment of tf file if required..."
terraform fmt
sleep 60  # Wait for 1 minute to ensure Terraform initialization
echo "Applying the Terraform plan with auto-approve..."
terraform apply -auto-approve | tee apply.log

# Extract Cluster Name and Region from Terraform outputs
print_message "Retrieving Terraform outputs for cluster configuration"

# Retrieve the EKS cluster name
CLUSTER_NAME=$(terraform output -raw eks_cluster_name) || {
    echo "Error: Unable to retrieve 'eks_cluster_name' from Terraform outputs."
    exit 1
}

# Retrieve the AWS region
REGION=$(terraform output -raw aws_region) || {
    echo "Error: Unable to retrieve 'aws_region' from Terraform outputs."
    exit 1
}

# Check if CLUSTER_NAME and REGION are retrieved successfully
if [ -z "$CLUSTER_NAME" ] || [ -z "$REGION" ]; then
    echo "Error: CLUSTER_NAME and REGION must be set."
    echo "Ensure that 'eks_cluster_name' and 'aws_region' are defined in your Terraform outputs."
    exit 1
fi

echo "Cluster Name: $CLUSTER_NAME"
echo "Region: $REGION"

# Wait for EKS cluster to become ACTIVE
print_message "Waiting for EKS cluster '$CLUSTER_NAME' to become ACTIVE in region '$REGION'..."
MAX_CLUSTER_STATUS_RETRIES=10
CLUSTER_STATUS_RETRY=0

until [ "$(aws eks describe-cluster --name "$CLUSTER_NAME" --region "$REGION" --query "cluster.status" --output text)" = "ACTIVE" ]; do
    CLUSTER_STATUS_RETRY=$((CLUSTER_STATUS_RETRY + 1))
    if [ "$CLUSTER_STATUS_RETRY" -ge "$MAX_CLUSTER_STATUS_RETRIES" ]; then
        echo "Error: EKS cluster '$CLUSTER_NAME' is not ACTIVE after $MAX_CLUSTER_STATUS_RETRIES attempts."
        exit 1
    fi
    echo "Cluster status is not ACTIVE yet. Waiting for 30 seconds... ($CLUSTER_STATUS_RETRY/$MAX_CLUSTER_STATUS_RETRIES)"
    sleep 30
done
echo "EKS cluster '$CLUSTER_NAME' is ACTIVE."

# Configure kubectl for the EKS cluster using eksctl
print_message "Configuring kubectl for the EKS cluster"
eksctl utils write-kubeconfig --cluster="$CLUSTER_NAME" --region="$REGION"

# Verify kubectl can communicate with the cluster with retry limit
print_message "Verifying kubectl connectivity with the cluster"

MAX_KUBECTL_RETRIES=10
KUBECTL_RETRY=0

until kubectl get nodes; do
    KUBECTL_RETRY=$((KUBECTL_RETRY + 1))
    if [ "$KUBECTL_RETRY" -ge "$MAX_KUBECTL_RETRIES" ]; then
        echo "Error: Kubernetes cluster is not ready after $MAX_KUBECTL_RETRIES attempts."
        exit 1
    fi
    echo "Waiting for Kubernetes cluster to be ready... ($KUBECTL_RETRY/$MAX_KUBECTL_RETRIES)"
    sleep 30
done

echo "kubectl is configured and the cluster is ready."

## Install ArgoCD
print_message "Installing ArgoCD"
kubectl create namespace argocd || echo "Namespace 'argocd' already exists."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

## Install ArgoCD CLI
sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd
print_message "Check argocd services"
kubectl get svc -n argocd

## Install Kubernetes Dashboard
print_message "Installing Kubernetes Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

## Install Helm
print_message "Installing Helm"
if ! command_exists helm; then
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
else
    echo "Helm is already installed."
fi

## Add Helm repositories
print_message "Adding Helm repositories"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || echo "Helm repo 'prometheus-community' already exists."
helm repo add stable https://charts.helm.sh/stable || echo "Helm repo 'stable' already exists."
helm repo update
helm repo list

## Install Prometheus and Grafana using Helm
print_message "Installing Prometheus and Grafana using Helm"
kubectl create namespace prometheus || echo "Namespace 'prometheus' already exists."
kubectl get ns
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
kubectl get pods -n prometheus

# kubectl create namespace monitoring || echo "Namespace 'monitoring' already exists."

# helm install kind-prometheus prometheus-community/kube-prometheus-stack \
#   --namespace monitoring \
#   --set prometheus.service.nodePort=30000 \
#   --set prometheus.service.type=NodePort \
#   --set grafana.service.nodePort=31000 \
#   --set grafana.service.type=NodePort \
#   --set alertmanager.service.nodePort=32000 \
#   --set alertmanager.service.type=NodePort \
#   --set prometheus-node-exporter.service.nodePort=32001 \
#   --set prometheus-node-exporter.service.type=NodePort 
kubectl get svc -n prometheus || {
      echo "Prometheus and Grafana are already installed in the 'prometheus' namespace."
  }

print_message "Installation script completed successfully."
