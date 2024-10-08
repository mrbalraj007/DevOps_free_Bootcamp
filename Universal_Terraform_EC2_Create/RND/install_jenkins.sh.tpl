#!/bin/bash
# install_jenkins.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Update the system
apt-get update -y
apt-get upgrade -y

# Install necessary dependencies
apt-get install -y openjdk-17-jdk wget gnupg2 ca-certificates apt-transport-https

# Remove any existing Jenkins repository and keyring to prevent conflicts
rm -f /etc/apt/sources.list.d/jenkins.list
rm -f /usr/share/keyrings/jenkins-keyring.gpg

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  
# Update the package list after adding Jenkins repo
apt-get update -y

# Install Jenkins
apt-get install -y jenkins

# Start and enable Jenkins service
systemctl start jenkins
systemctl enable jenkins

# **Optional:** Adjust the firewall to allow port 8080
# If you're managing firewall rules using AWS Security Groups exclusively, you can comment out or remove these commands.
ufw allow 8080
ufw allow OpenSSH
ufw --force enable

# Create a local user named Balraj with a predefined password
useradd -m -s /bin/bash Balraj
echo "Balraj:${balraj_password}" | chpasswd

# Add Balraj to the sudoers file for password-less sudo access
echo "Balraj ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/balraj > /dev/null

# Install Jenkins Configuration as Code (JCasC) plugin for automation
systemctl stop jenkins
mkdir -p /var/lib/jenkins/plugins
wget https://updates.jenkins.io/download/plugins/configuration-as-code/1.51/configuration-as-code.hpi -P /var/lib/jenkins/plugins/
chown jenkins:jenkins /var/lib/jenkins/plugins/configuration-as-code.hpi

# Create JCasC configuration file
tee /var/lib/jenkins/casc.yaml > /dev/null <<EOL
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "balraj"
          password: "${balraj_password}"
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
EOL

chown jenkins:jenkins /var/lib/jenkins/casc.yaml

# Restart Jenkins to apply configurations
systemctl start jenkins

# Wait for Jenkins to initialize
sleep 30

# Fetch the initial admin password and save it to a file
cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ubuntu/jenkins_initial_password.txt
chown ubuntu:ubuntu /home/ubuntu/jenkins_initial_password.txt
