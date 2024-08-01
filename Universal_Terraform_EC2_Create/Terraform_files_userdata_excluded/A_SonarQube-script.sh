#!/bin/bash
 
sudo -i

# Define the new hostname
NEW_HOSTNAME="controller"

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

# Install kubectl
curl -Lo kubectl https://dl.k8s.io/release/$(curl -s -L https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /bin/kubectl

# Install Kops

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /bin/

