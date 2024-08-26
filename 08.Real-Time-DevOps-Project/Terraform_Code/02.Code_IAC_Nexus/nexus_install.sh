#!/bin/bash
sudo apt update -y
#sudo apt install temurin-17-jdk -y
sudo apt install openjdk-17-jre-headless -y
/usr/bin/java --version

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

sudo docker run -d --name nexus3 -p 8081:8081 sonatype/nexus3

