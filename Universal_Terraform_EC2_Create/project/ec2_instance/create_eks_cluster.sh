#!/bin/bash

# Update and install necessary packages
sudo apt-get update -y
sudo apt-get install -y unzip

# Install Terraform
curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/

# Install AWS CLI
curl -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS CLI using environment variables
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_REGION=${AWS_REGION}

# Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Create EKS Cluster
cd /home/ubuntu/eks_cluster
terraform init
terraform apply -auto-approve
