#!/bin/bash

sudo apt-get update -y

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
sudo systemctl reload ssh

# Set Root password
echo "[TASK 2] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1


# # Download Grafana
# sudo apt-get update
# sudo apt install wget curl  -y
# sudo apt-get install -y adduser libfontconfig1 musl
# wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.1.4_amd64.deb
# sudo dpkg -i grafana-enterprise_11.1.4_amd64.deb
# sudo /bin/systemctl start grafana-server


#################################################################

# Update the package list
sudo apt-get update

# Install dependencies
sudo apt-get install -y apt-transport-https software-properties-common wget

# Add Grafana GPG key
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana APT repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update the package list again
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Verify installation
grafana-server -v

echo "Grafana has been installed successfully."


# To download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.54.0/prometheus-2.54.0.linux-amd64.tar.gz
tar -xvf prometheus-2.54.0.linux-amd64.tar.gz
# rm prometheus-2.54.0.linux-amd64.tar.gz
mv prometheus-2.54.0.linux-amd64 prometheus


# To download black box
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz
# rm blackbox_exporter-0.25.0.linux-amd64.tar.gz
mv blackbox_exporter-0.25.0.linux-amd64/ blackbox


























# **************************************


# # Update package lists
# sudo apt-get update

# # Set the version of Prometheus
# VERSION="2.54.0"

# # Create a temporary directory for the download
# TEMP_DIR=$(mktemp -d)

# # Navigate to the temporary directory
# cd $TEMP_DIR

# # Download the latest Prometheus tarball
# wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz

# # Extract the tarball
# tar -xvzf prometheus-$VERSION.linux-amd64.tar.gz

# # Move Prometheus binaries to /usr/local/bin
# sudo mv prometheus-$VERSION.linux-amd64/prometheus /usr/local/bin/
# sudo mv prometheus-$VERSION.linux-amd64/promtool /usr/local/bin/

# # Clean up
# rm -rf $TEMP_DIR

# sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
# [Unit]
# Description=Prometheus
# Wants=network-online.target
# After=network-online.target

# [Service]
# User=root
# ExecStart=/usr/local/bin/prometheus \
#   --config.file=/etc/prometheus/prometheus.yml \
#   --storage.tsdb.path=/var/lib/prometheus/data \
#   --web.console.templates=/etc/prometheus/consoles \
#   --web.console.libraries=/etc/prometheus/console_libraries
# Restart=always

# [Install]
# WantedBy=multi-user.target
# EOF


# # Start and enable Prometheus service
# sudo systemctl daemon-reload
# sudo systemctl enable prometheus
# sudo systemctl start prometheus

# # Verify installation
# prometheus --version
# promtool --version

# echo "Prometheus $VERSION has been installed successfully."

# # **************************************************************

# # Set the version of Blackbox Exporter
# VERSION="0.25.0"

# # Create a temporary directory for the download
# TEMP_DIR=$(mktemp -d)

# # Navigate to the temporary directory
# cd $TEMP_DIR

# # Download the latest Blackbox Exporter tarball
# wget https://github.com/prometheus/blackbox_exporter/releases/download/v$VERSION/blackbox_exporter-$VERSION.linux-amd64.tar.gz

# # Extract the tarball
# tar -xvzf blackbox_exporter-$VERSION.linux-amd64.tar.gz

# # Move Blackbox Exporter binaries to /usr/local/bin
# sudo mv blackbox_exporter-$VERSION.linux-amd64/blackbox_exporter /usr/local/bin/

# # Clean up
# rm -rf $TEMP_DIR

# sudo tee /etc/systemd/system/blackbox_exporter.service > /dev/null <<EOF
# [Unit]
# Description=Blackbox Exporter
# Wants=network-online.target
# After=network-online.target

# [Service]
# User=root
# ExecStart=/usr/local/bin/blackbox_exporter \
#   --config.file=/etc/blackbox_exporter/config.yml
# Restart=always

# [Install]
# WantedBy=multi-user.target
# EOF


# # Start and enable Blackbox Exporter service
# sudo systemctl daemon-reload
# sudo systemctl enable blackbox_exporter
# sudo systemctl start blackbox_exporter

# # Verify installation
# blackbox_exporter --version

# echo "Blackbox Exporter $VERSION has been installed successfully."
