#### Environment Setup
```bash
Hostname: maven
IP Address: 192.168.1.250
```

*Password Less Authentication*

```bash
To set in sudoers file
path=/etc/sudoers 
dev-ops ALL=(ALL) NOPASSWD: ALL

cat /etc/sudoers | grep -i "dev-ops"
echo "dev-ops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cat /etc/sudoers | grep -i "dev-ops"

cat /etc/ssh/sshd_config | grep "PasswordAuthentication"
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep "PasswordAuthentication"

cat /etc/ssh/sshd_config | grep "PermitRootLogin"
echo "PermitRootLogin yes"  >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep "PermitRootLogin"
```

*Restart the sshd reservices.*
```
systemctl restart sshd
systemctl daemon-reload

or 

Restart the sshd service In Ubuntu
/etc/init.d/ssh restart
sudo service ssh restart
sudo restart ssh
```

### first update the package so that it would be ready for available.
```bash
sudo apt-get update
```

Install the git because I'll cloning my Github Repo: 
```bash
sudo apt-get install git -y
```

- will verify ```java``` is avaliable or not because to install ```maven``` java should be installed on the system.
```bash
$ java
Command 'java' not found, but can be installed with:
sudo apt install default-jre              # version 2:1.17-75, or
sudo apt install openjdk-17-jre-headless  # version 17.0.10~6ea-1
sudo apt install openjdk-11-jre-headless  # version 11.0.21+9-0ubuntu1
sudo apt install openjdk-19-jre-headless  # version 19.0.2+7-4
sudo apt install openjdk-20-jre-headless  # version 20.0.2+9-1
sudo apt install openjdk-21-jre-headless  # version 21.0.1+12-3
sudo apt install openjdk-22-jre-headless  # version 22~22ea-1
sudo apt install openjdk-8-jre-headless   # version 8u392-ga-1
```
- Install the Java
```bash
$ sudo apt install openjdk-17-jre-headless -y
```

- verify the java version
```bash
$ java --version
openjdk 17.0.11 2024-04-16
OpenJDK Runtime Environment (build 17.0.11+9-Ubuntu-1)
OpenJDK 64-Bit Server VM (build 17.0.11+9-Ubuntu-1, mixed mode, sharing)
```

verify maven install or not
```bash
$ mvn
Command 'mvn' not found, but can be installed with:
sudo apt install maven
```

will install the maven
```bash
$ sudo apt install maven -y
```

- maven version
```bash
$ mvn --version
Apache Maven 3.8.7
Maven home: /usr/share/maven
Java version: 17.0.11, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "6.8.0-31-generic", arch: "amd64", family: "unix"
```
