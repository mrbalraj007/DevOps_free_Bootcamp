#!/bin/bash
sudo apt update -y

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


docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
