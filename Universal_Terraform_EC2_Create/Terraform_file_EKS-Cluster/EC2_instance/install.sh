#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install AWS CLI
sudo apt-get install -y awscli

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Configure AWS CLI
mkdir -p ~/.aws

cat <<EOL > ~/.aws/config
[default]
region = ${AWS_REGION}
output = json
EOL

cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOL

# Verify installation
aws --version
kubectl version --client
