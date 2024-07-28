#!/bin/bash

# Define Splunk credentials and installation directory
SPLUNK_USERNAME="admin"
SPLUNK_PASSWORD="your_password_here"
SPLUNK_INSTALL_DIR="/opt/splunk"
USER_SEED_CONF="/opt/splunk/etc/system/local/user-seed.conf"

# Update and install required dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y wget tar

# Get the latest Splunk version URL
echo "Fetching latest Splunk version..."
SPLUNK_URL=$(wget -qO- https://www.splunk.com/en_us/download/splunk-enterprise.html | grep -oP 'https://download\.splunk\.com/products/splunk/releases/[^"]+-Linux-x86_64\.tgz' | head -n 1)

# Check if URL was found
if [ -z "$SPLUNK_URL" ]; then
    echo "Error: Could not find the Splunk download URL."
    exit 1
fi

# Download and extract Splunk
echo "Downloading Splunk..."
wget -O splunk.tgz "$SPLUNK_URL"

echo "Extracting Splunk..."
sudo tar -xzvf splunk.tgz -C /opt

# Set permissions
sudo chown -R root:root "$SPLUNK_INSTALL_DIR"

# Create user-seed.conf to set admin credentials
echo "Creating user-seed.conf for non-interactive user setup..."
sudo mkdir -p "$SPLUNK_INSTALL_DIR/etc/system/local"
sudo bash -c "cat > $USER_SEED_CONF" <<EOF
[user_info]
USERNAME = $SPLUNK_USERNAME
PASSWORD = $SPLUNK_PASSWORD
EOF

# Start Splunk and accept the license agreement
echo "Starting Splunk..."
sudo "$SPLUNK_INSTALL_DIR/bin/splunk" start --accept-license --answer-yes --no-prompt

# Ensure Splunk starts on boot
sudo "$SPLUNK_INSTALL_DIR/bin/splunk" enable boot-start

# Clean up
rm splunk.tgz

echo "Splunk installation completed. You can access the Splunk GUI at http://localhost:8000 with username '$SPLUNK_USERNAME' and the password you set."
