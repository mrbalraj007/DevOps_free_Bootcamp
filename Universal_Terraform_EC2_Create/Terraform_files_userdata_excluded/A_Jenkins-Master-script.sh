#!/bin/bash
 
sudo -i

# Define the new hostname
NEW_HOSTNAME="jenkins"

# Set the new hostname
sudo hostnamectl set-hostname $NEW_HOSTNAME

# Restart the systemd-logind service
sudo systemctl restart systemd-logind.service

# Print the new hostname
echo "The hostname has been changed to: $NEW_HOSTNAME"

# Append configurations to /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config


# Restart SSH service and reload daemon
systemctl restart sshd
systemctl daemon-reload


# https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/

# Update the package index
sudo yum update –y

# Install Java (Amazon Linux 2023):
sudo yum install java-17-amazon-corretto git tmux -y

# Add the Jenkins repo using the following command:
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

 # Import a key file from Jenkins-CI to enable installation from the package:   
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum upgrade -y

# Install Jenkins
sudo yum install jenkins -y

# Enable and start Jenkins service
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
# sudo systemctl status jenkins


