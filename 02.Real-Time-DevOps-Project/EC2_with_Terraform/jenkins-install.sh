#!/bin/bash

sudo yum update -y
sudo yum install wget java-17-amazon-corretto git -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

#============================================================Will delete it ============================
# # 00. To install Jenkins (https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/)

# #Bootstrap Jenkins installation and start  
# sudo yum update -y 
# sudo yum install wget -y 
#  # updates the package list and upgrades installed packages on the system
# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo  #downloads the Jenkins repository configuration file and saves it to /etc/yum.repos.d/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key  #imports the GPG key for the Jenkins repository. This key is used to verify the authenticity of the Jenkins packages
# sudo yum upgrade -y #  upgrades packages again, which might be necessary to ensure that any new dependencies required by Jenkins are installed
# sudo dnf install java-17-amazon-corretto -y  # installs Amazon Corretto 11, which is a required dependency for Jenkins.
# sudo yum install jenkins -y  #installs Jenkins itself
# sudo systemctl enable jenkins  #enables the Jenkins service to start automatically at boot time
# sudo systemctl start jenkins   #starts the Jenkins service immediately

# sudo yum update -y

# # Add the Jenkins repo using the following command:
# sudo wget -O /etc/yum.repos.d/jenkins.repo \
#     https://pkg.jenkins.io/redhat-stable/jenkins.repo

# # Import a key file from Jenkins-CI to enable installation from the package:
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# sudo yum upgrade

# # Install Java (Amazon Linux 2023):
# sudo dnf install java-17-amazon-corretto -y

# # Install Jenkins:
# sudo yum install jenkins -y

# # Enable the Jenkins service to start at boot:
# sudo systemctl enable jenkins

# # Start Jenkins as a service:
# sudo systemctl start jenkins
#============================================================Will delete it ============================

# 01. To install git
sudo yum install git -y

# 02. To install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# 03. To install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

