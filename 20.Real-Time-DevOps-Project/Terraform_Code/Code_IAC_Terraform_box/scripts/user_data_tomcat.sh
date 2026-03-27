#!/bin/bash

set -e
set -o pipefail

print_message() {
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

# Change hostname to 'tomcat-svr'
print_message "Setting hostname to 'tomcat-svr'"
sudo hostnamectl set-hostname tomcat-svr

# Create user 'ansadmin' if it doesn't already exist
if ! id "ansadmin" &>/dev/null; then
    print_message "Creating user 'ansadmin'"
    sudo useradd -m -s /bin/bash ansadmin
    echo "ansadmin:password" | sudo chpasswd
    echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansadmin
else
    echo "User 'ansadmin' already exists."
fi

# Enable password-based SSH login
print_message "Configuring SSH for password-based authentication"
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Generate SSH key for ansadmin user
print_message "Generating SSH key for 'ansadmin' user"
sudo -u ansadmin bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
if [ ! -f /home/ansadmin/.ssh/id_rsa ]; then
    sudo -u ansadmin ssh-keygen -t rsa -b 2048 -f /home/ansadmin/.ssh/id_rsa -N ""
    echo "SSH key generated for 'ansadmin' user."
else
    echo "SSH key already exists for 'ansadmin' user."
fi


# Update the system and install Java if not installed
print_message "Updating system and installing OpenJDK"
sudo apt update -y
sudo apt install -y openjdk-11-jdk

# Check if Java is installed
if ! java -version >/dev/null 2>&1; then
    echo "Java installation failed. Exiting."
    exit 1
else
    echo "Java successfully installed."
fi

# Set Tomcat version and installation directory
TOMCAT_VERSION=9.0.73
TOMCAT_DIR=/opt/tomcat
TOMCAT_TAR_URL="https://archive.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
TOMCAT_TAR_FILE="/tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz"

# Download Tomcat with retry mechanism
print_message "Downloading Tomcat version $TOMCAT_VERSION"
download_success=0
for i in {1..3}; do
    wget -O "$TOMCAT_TAR_FILE" "$TOMCAT_TAR_URL" && download_success=1 && break
    echo "Attempt $i to download Tomcat failed. Retrying..."
    sleep 2
done

if [[ $download_success -ne 1 ]]; then
    echo "Failed to download Tomcat after multiple attempts."
    exit 1
fi

# Extract Tomcat package
sudo tar -xzf "$TOMCAT_TAR_FILE" -C /opt
sudo mv /opt/apache-tomcat-$TOMCAT_VERSION $TOMCAT_DIR
sudo rm -f "$TOMCAT_TAR_FILE"

# Configure Tomcat permissions
print_message "Configuring Tomcat permissions"
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
sudo chown -R tomcat:tomcat $TOMCAT_DIR
sudo chmod -R 755 $TOMCAT_DIR

# Create a systemd service file for Tomcat
print_message "Creating systemd service file for Tomcat"
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 9 Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=$TOMCAT_DIR"
Environment="CATALINA_BASE=$TOMCAT_DIR"

ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=$TOMCAT_DIR/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon and start Tomcat
print_message "Starting and enabling Tomcat service"
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Check Tomcat status and log
if sudo systemctl status tomcat | grep -q "active (running)"; then
    echo "Tomcat is successfully installed and running."
else
    echo "Tomcat failed to start. Checking logs for details..."
    sudo tail -n 50 /opt/tomcat/logs/catalina.out
    exit 1
fi

# Configure firewall (if ufw is active) to allow traffic on port 8080
if command -v ufw >/dev/null 2>&1; then
    print_message "Allowing traffic on port 8080"
    sudo ufw allow 8080
fi

print_message "Tomcat installation and setup complete. Access Tomcat server on port 8080."
