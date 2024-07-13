#!/bin/bash

# Variables
SONARQUBE_VERSION=9.9.0.65466

# Update the package repository and install prerequisites
sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk wget unzip

# Download and unzip SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
unzip sonarqube-${SONARQUBE_VERSION}.zip -d /opt
sudo mv /opt/sonarqube-${SONARQUBE_VERSION} /opt/sonarqube

# Create a SonarQube user
sudo useradd -r -s /bin/false sonar
sudo chown -R sonar:sonar /opt/sonarqube

# Configure SonarQube to use an embedded H2 database
sudo sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username=sonar|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password=sonar|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar|sonar.jdbc.url=jdbc:h2:mem:sonar|' /opt/sonarqube/conf/sonar.properties

# Create systemd service file for SonarQube
sudo bash -c 'cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF'

# Start and enable SonarQube service
sudo systemctl start sonarqube
sudo systemctl enable sonarqube

# Print SonarQube status to verify installation
sudo systemctl status sonarqube

# Clean up
rm sonarqube-${SONARQUBE_VERSION}.zip

# Print Java version to verify installation
java -version
