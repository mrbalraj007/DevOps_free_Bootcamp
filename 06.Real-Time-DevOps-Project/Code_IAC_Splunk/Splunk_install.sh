#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
SPLUNK_HOME="/opt/splunk"
SPLUNK_USER="splunk"
SPLUNK_GROUP="splunk"
SPLUNK_PASSWORD="MySecurePass123"  # Change this to a secure password
SPLUNK_USERNAME="admin"  # Change this to the desired username

# Update and install necessary packages
sudo apt-get update -y
sudo apt-get install -y wget tar curl

# Create a Splunk user and group
sudo groupadd -r $SPLUNK_GROUP
sudo useradd -r -m -d $SPLUNK_HOME -g $SPLUNK_GROUP $SPLUNK_USER

# Fetch the latest Splunk download URL dynamically
SPLUNK_URL=$(curl -s https://www.splunk.com/en_us/download/splunk-enterprise.html | grep -oP 'https://download\.splunk\.com/products/splunk/releases/[0-9\.]+/linux/splunk-[0-9\.]+-[a-z0-9]+-Linux-x86_64\.tgz' | head -1)

# Download the latest version of Splunk
wget -O splunk-latest-linux-x86_64.tgz "$SPLUNK_URL"

# Extract the tar file to the /opt directory
sudo tar -xvzf splunk-latest-linux-x86_64.tgz -C /opt

# Set permissions
sudo chown -R $SPLUNK_USER:$SPLUNK_GROUP $SPLUNK_HOME

# Accept the license agreement and start Splunk
sudo -u $SPLUNK_USER $SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --no-prompt

# Complete the initial setup with username and password
sudo -u $SPLUNK_USER $SPLUNK_HOME/bin/splunk edit user $SPLUNK_USERNAME -password $SPLUNK_PASSWORD -role admin -auth $SPLUNK_USERNAME:changeme

# Enable Splunk to start at boot
sudo $SPLUNK_HOME/bin/splunk enable boot-start -user $SPLUNK_USER

# Cleanup
rm splunk-latest-linux-x86_64.tgz

echo "Splunk installation is complete."
