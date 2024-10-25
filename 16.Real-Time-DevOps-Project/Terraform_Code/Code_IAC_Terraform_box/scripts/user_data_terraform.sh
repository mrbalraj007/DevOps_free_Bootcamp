#!/bin/bash

# Set the hostname and update the system
sudo hostnamectl set-hostname Terraform-svr
sudo apt-get update -y
sudo apt-get install -y curl wget gnupg software-properties-common

# Install Terraform
# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# sudo apt-get update -y
# sudo apt-get install -y terraform

sudo apt-get update -y
sudo apt-get install -y curl wget gnupg software-properties-common
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt-get install terraform -y

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Grant Docker access to the ubuntu user
sudo usermod -aG docker ubuntu

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Verify Docker installation
echo "Checking Docker version..."
docker --version || { echo "Docker installation failed"; exit 1; }

# Pull the Docker image
echo "Pulling Docker image ghcr.io/conradludgate/spotify-auth-proxy..."
docker pull ghcr.io/conradludgate/spotify-auth-proxy || { echo "Docker image pull failed"; exit 1; }

# Verify image pull success
docker images | grep "ghcr.io/conradludgate/spotify-auth-proxy" || { echo "Image not found in local Docker images"; exit 1; }

# Create directory for Spotify configuration and navigate there
mkdir -p /home/ubuntu/spotify
cd /home/ubuntu/spotify

# Running the Docker container
echo "Running Docker container for Spotify Auth Proxy..."
docker run -itd -p 27228:27228 --env-file /home/ubuntu/spotify/.env ghcr.io/conradludgate/spotify-auth-proxy || { echo "Docker container failed to start"; exit 1; }

# Sleep for 1 minutes to allow the container to initialize
echo "Waiting for container initialization..."
sleep 60

# Check running containers
docker ps | grep "spotify-auth-proxy" || { echo "Spotify container is not running"; exit 1; }

# Get the container ID
container_id=$(docker ps -q --filter ancestor=ghcr.io/conradludgate/spotify-auth-proxy)

# Debugging: print the container logs to verify the presence of APIKey
echo "Container logs for debugging:"
docker logs $container_id

# Fetch the APIKey from the container logs
api_key=$(docker logs $container_id | grep 'APIKey:' | awk -F': ' '{print $2}' | tr -d '[:space:]')

# Debugging: print the api_key variable to verify the value fetched
echo "Debug: APIKey retrieved is '$api_key'"

# Ensure APIKey is retrieved
if [ -z "$api_key" ]; then
    echo "Error: APIKey not found in container logs."
    docker logs $container_id  # Output full logs for debugging
    exit 1
else
    echo "APIKey successfully retrieved: $api_key"
fi

# Clear the contents of terraform.tfvars and append the new APIKey
echo "Clearing terraform.tfvars and updating with the retrieved APIKey..."
echo "spotify_api_key=\"$api_key\"" > terraform.tfvars

# To Show container logs:

echo "To show container logs..."
docker container logs $container_id 
# # Initialize and apply Terraform
# echo "Initializing and applying Terraform configuration..."
# terraform init
# terraform apply -auto-approve | tee apply.log