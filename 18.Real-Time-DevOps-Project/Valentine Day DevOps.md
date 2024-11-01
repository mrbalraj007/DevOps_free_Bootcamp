# <span style="color: Yellow;"> DevOps Love Story: CI/CD Pipeline for Valentine's Day</span>
This Valentine’s Day DevOps CI/CD project offers an entertaining DevOps-themed walkthrough with Jenkins, SonarQube, Docker, and Trivy, focusing on a playful web app with a Valentine theme. It demonstrates an end-to-end pipeline setup, from setting up Jenkins and Docker to configuring code quality checks with SonarQube and conducting security scans with Trivy.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/18.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo](https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git)

- [x] __Git and GitHub__: You'll need to know the basics of Git for version control and GitHub for managing your repository.
- [x] __Jenkins Installed__: You need a running Jenkins instance for continuous integration and deployment.
- [x] __Docker__: Familiarity with Docker is essential for building and managing container images.
- [x] __SonarQube__: For code quality checks, deployed on Docker.
- [x] __Trivy__: For filesystem and Docker image scanning, showcasing security scanning features.

## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform code to set up the entire environment, including the installation of required applications, tools.

- &rArr; <span style="color: brown;">EC2 machines will be created named as ```"Jenkins```
- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Trivy Install
- &rArr;<span style="color: brown;"> SonarQube install as in a container

### <span style="color: Yellow;"> EC2 Instances creation

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"18.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
da---l          07/10/24   4:01 PM                scripts
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          09/10/24  10:57 AM           8351 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

da---l          07/10/24   4:01 PM                scripts
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          09/10/24  10:57 AM           8351 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
```
You need to run ```main.tf``` file using following terraform command.

Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional <terraform apply --auto-approve>
```
-------

Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```Cloud-Init``` logs</span>: 
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files]([cloud-init-output.log](https://github.com/user-attachments/files/17321314/cloud-init-output.log)).
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- If the user_data script runs successfully, you will see output logs and any errors encountered during execution.
- If there’s an error, this log will provide clues about what failed.

Outcome of "```cloud-init-output.log```"

### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1

docker ps -a
ubuntu@ip-172-31-94-25:~$ docker ps
```

- [x] <span style="color: brown;"> trivy version
```bash
ubuntu@ip-172-31-89-97:~$ trivy version
Version: 0.55.2
```
- [x] <span style="color: brown;"> Terraform version
```bash
ubuntu@ip-172-31-89-97:~$ terraform version
Terraform v1.9.6
on linux_amd64
```
- [x] <span style="color: brown;"> aws cli version
```bash
ubuntu@ip-172-31-89-97:~$ aws version
usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:
  aws help
  aws <command> help
  aws <command> <subcommand> help
```

## <span style="color: yellow;"> Setup the Jenkins </span>
Go to Jenkins EC2 and run the following command 
Access Jenkins via ```http://<your-server-ip>:8080```. Retrieve the initial admin password using:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![image-4](https://github.com/user-attachments/assets/1fc5315b-0fe1-4a5a-bb7c-fd20645adbb4)
![image-5](https://github.com/user-attachments/assets/82ae7f28-7cae-476e-99ae-b1d1596c379e)
![image-6](https://github.com/user-attachments/assets/c966a1b3-96a2-4dc6-8329-a3b8f4ee93e3)
![image-7](https://github.com/user-attachments/assets/867887a1-9d3e-4d22-b37f-b63fac896620)
![image-8](https://github.com/user-attachments/assets/fc64c254-8d92-4e20-9ce0-76b1938a466a)

### <span style="color: cyan;"> Install the plugin in Jenkins </span>
Manage Jenkins > Plugins view> Under the Available tab, plugins available for download from the configured Update Center can be searched and considered:

```sh
Blue Ocean
Pipeline: Stage View
Docker
Docker Pipeline
Docker-build-step
SonarQube Scanner
```

### <span style="color: cyan;"> Configure SonarQube </span>

<public IP address: 9000>

![image-15](https://github.com/user-attachments/assets/ab812f25-e5ec-4346-a4b6-967883a343a2)
  default login : admin/admin <br>
  You have to change password as per below screenshot
![image-16](https://github.com/user-attachments/assets/f35e952a-249a-4788-b9d4-fbaa1348f5ca)


## <span style="color: yellow;"> Configure the tools </span> 

#### <span style="color: cyan;"> Configure the ```sonarqube scanner``` in Jenkins.</span>
> Dashboard> Manage Jenkins> Tools

Search for ```SonarQube Scanner installations``` 
![image-28](https://github.com/user-attachments/assets/a6eb21a9-c5e9-4e3d-89c5-da58a5b5cfa2)
![image-20](https://github.com/user-attachments/assets/aed4baa6-f96e-4018-b16d-1ebd84aa47eb)


- create a below pipeline and build it and verify the outcomes.
```bash
pipeline {
    agent any

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
                echo "This is cloning the code"
            }
        }
    }
}
```
![image](https://github.com/user-attachments/assets/d886b397-485b-4cc6-b74c-667919dcfe1e)


<!-- ```sh
pipeline {
    agent any
 
    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
    }
}
``` -->

### <span style="color: cyan;"> Integrate SonarQube in Jenkins.</span>
Go to Sonarqube and generate the token

> Administration> Security> users>

![image-24](https://github.com/user-attachments/assets/30d99980-a369-4409-bb73-14b943fbfe14)
![image-25](https://github.com/user-attachments/assets/3b4d4339-2e5c-4fb4-916b-05259ff52100)
![image-26](https://github.com/user-attachments/assets/8d8e4a99-6de7-452f-af08-e32a70d129b3)


now, open Jenkins UI and create a credential for sonarqube
> Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
![image-24](https://github.com/user-attachments/assets/b3a0605c-38b0-4353-977d-669a6aa41f76)



#### <span style="color: cyan;"> Configure the ```sonarqube server``` in Jenkins.</span>
On Jenkins UI:
  > Dashboard> Manage Jenkins> System > Search for ```SonarQube installations``` 
![image-25](https://github.com/user-attachments/assets/c1c489b3-6f9b-47c7-a3bf-89e8083ca787)

        Name: sonar
        server URL: <http:Sonarqube IP address:9000>
        Server authenticatoin Token: select the sonarqube token from list.
![image-26](https://github.com/user-attachments/assets/46cbae72-16c5-41ac-9d38-0a0d2b319e6b)

- build a pipeline with sonarqube parameter
```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
    }
}
```

![image-1](https://github.com/user-attachments/assets/a631e1fa-d729-4105-9db3-f0d287cd1ae1)



- add docker build and tag to image

```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                echo 'This step for building a docker image and tag it'
                sh "docker build -t balrajsi/valentine:v1 ."
            }
        }
    }
}
```
#### Build Failed
- ###### Troubleshooting

I was getting below error message

```sh
[Pipeline] { (Build and Tag Docker Image)
[Pipeline] echo
This step for building a docker image and tag it
[Pipeline] sh
+ docker build -t balrajsi/valentine:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?buildargs=%7B%7D&cachefrom=%5B%5D&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=dockerfile&labels=%7B%7D&memory=0&memswap=0&networkmode=default&rm=1&shmsize=0&t=balrajsi%2Fvalentine%3Av1&target=&ulimits=null&version=1": dial unix /var/run/docker.sock: connect: permission denied
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE
```
> Solution:

     ```sh
        Add Jenkins to the Docker Group:

        Run the following command to add the jenkins user to the docker group:

        ```bash
        sudo usermod -aG docker jenkins
        ```
        After adding Jenkins to the Docker group, restart the Jenkins service to apply the changes:
        ```bash
        sudo systemctl restart jenkins
        ```
        Verify Docker Permissions:

        Confirm that the docker group has appropriate permissions for /var/run/docker.sock:
        ```bash
        sudo chmod 666 /var/run/docker.sock
        ```
        This command makes the Docker socket accessible to all users, which is useful for testing but should be secured in production.
        ```
![image-2](https://github.com/user-attachments/assets/d230f272-e67e-4227-854a-7b069a472601)




- Add docker credential.
  
![image-3](https://github.com/user-attachments/assets/41f26657-f264-4d50-a00e-76d73427d102)

> updated pipeline
```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                     echo 'This step for building a docker image and tag it'
                     sh "docker build -t balrajsi/valentine:v1 ."
                   }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                echo 'This step for scanning docker image'
                sh "trivy image --format json -o trivy-image-report.json balrajsi/valentine:v1"
            }
        }
        
    }
}
```
- Again build failed 
![image-4](https://github.com/user-attachments/assets/ac1c5e11-3c91-48c0-82d4-6449483229bb)

- Issue: less space reported on drive.
![image-5](https://github.com/user-attachments/assets/38e3405e-bcd6-4f66-93d5-553f7bfb7591)


**solution:**
- Exend the drive 
```sh
Yes, after modifying the volume size in AWS, you'll need to extend the partition within the Ubuntu OS so that the filesystem recognizes the new space. Here are the steps to extend the root volume:

Check the new disk size to confirm that the OS recognizes the additional storage:
```bash
lsblk
```
You should see /dev/nvme0n1 with the new 20 GB size.

Extend the partition: Use growpart to extend the partition to the full size of the disk. First, install cloud-guest-utils if it's not already installed:
```bash
sudo apt update
sudo apt install cloud-guest-utils -y
```
Then extend the partition:
```bash
sudo growpart /dev/nvme0n1 1
```
Resize the filesystem: After extending the partition, resize the filesystem to use the additional space:
```bash
sudo resize2fs /dev/root
```
Verify the updated size: Check that the filesystem now reflects the increased space:
```bash
df -h
```
This should show /dev/root with approximately 20 GB of total space available.
```

```sh
Before: Disk Utilization

ubuntu@Jenkins-svr:~$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.8G  5.4G  1.4G  81% /
tmpfs            1.9G     0  1.9G   0% /dev/shm
tmpfs            768M 1008K  767M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   76M  744M  10% /boot
/dev/nvme0n1p15  105M  6.1M   99M   6% /boot/efi
tmpfs            384M   12K  384M   1% /run/user/1000


After: Disk Utilization
ubuntu@Jenkins-svr:~$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         19G  5.4G   13G  30% /
tmpfs            1.9G     0  1.9G   0% /dev/shm
tmpfs            768M 1012K  767M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   76M  744M  10% /boot
/dev/nvme0n1p15  105M  6.1M   99M   6% /boot/efi
tmpfs            384M   12K  384M   1% /run/user/1000
```

Build the pipeline again it goes well.

![image-6](https://github.com/user-attachments/assets/99df4b61-7e2a-4cdc-a4ee-8e0acdfcfb1a)



- Apend the pipeline to push docker image
  
```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                     echo 'This step for building a docker image and tag it'
                     sh "docker build -t balrajsi/valentine:v1 ."
                   }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                echo 'This step for scanning docker image'
                sh "trivy image --format json -o trivy-image-report.json balrajsi/valentine:v1"
            }
        }
         stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        echo 'This step for pushing image to docker hub'
                        sh "docker push balrajsi/valentine:v1"
                    }
                }
            }
         }    
    }
}
```
- outcomes
![image-7](https://github.com/user-attachments/assets/096f0ab1-3818-4e8c-9e6b-358f2687e34f)

- view from Docker Hub
![image-8](https://github.com/user-attachments/assets/eee17736-80af-4dfa-afb9-1fafa80dd292)

- Apend the pipeline to Deploy image to container
```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                     echo 'This step for building a docker image and tag it'
                     sh "docker build -t balrajsi/valentine:v1 ."
                   }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                echo 'This step for scanning docker image'
                sh "trivy image --format json -o trivy-image-report.json balrajsi/valentine:v1"
            }
        }
        stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        echo 'This step for pushing image to docker hub'
                        sh "docker push balrajsi/valentine:v1"
                    }
                }
            }
        }
        stage ('Deploy to Container') {
         steps {
             sh 'docker run -d -p 8081:80 balrajsi/valentine:v1'
         }
        }
    }
}
```
- Pipeline status
![image-9](https://github.com/user-attachments/assets/31747b53-98e5-4b42-8f25-02fa76902517)

- Try to access application 

```http://publicIPAddressofServer:8081```
```sh
http://35.174.11.211:8081/
```
![image-10](https://github.com/user-attachments/assets/3ded6482-2013-4ad8-b05a-970fe87c0b35)

- Application is accessible on below URL
```http://publicIPAddressofServer:8081/yes.html```
```bash
http://35.174.11.211:8081/yes.html
```

"If you try to build it again, it will fail because it will indicate that it already exists. Therefore, we are introducing Docker Compose, and the updated pipeline is provided below."

```sh
pipeline {
    agent any
    environment {
        SCANNER_Home= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git'
              
            }
        }
         stage('Trivy FileSystem Scan') {
            steps {
                echo 'This is for scan file system the code'
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
           stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar'){
                 echo 'Analysis the code'
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                     echo 'This step for building a docker image and tag it'
                     sh "docker build -t balrajsi/valentine:v1 ."
                   }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                echo 'This step for scanning docker image'
                sh "trivy image --format json -o trivy-image-report.json balrajsi/valentine:v1"
            }
        }
        stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        echo 'This step for pushing image to docker hub'
                        sh "docker push balrajsi/valentine:v1"
                    }
                }
            }
        }
        stage ('Deploy to Container') {
         steps {
             # // sh 'docker run -d -p 8081:80 balrajsi/valentine:v1'    # Remove the `hash` if you ware using the same pipeline.
             sh 'docker compose up -d'
         }
        }
    }
}
```


<!-- Now, we will configure the ```webhook``` for code quality check in Sonarqube
Open SonarQube UI:

![image-35](https://github.com/user-attachments/assets/09eaef57-dd2d-4767-aa52-3b0c91925a6c)

    <http://jenkinsIPAddress:8080/sonarqube-webhook/>

![image-36](https://github.com/user-attachments/assets/7a1b460b-95ef-4ae2-80c6-d57d1d7f1bdb)

#### <span style="color: cyan;"> Configure the Github in Jenkins.</span>
First generate the token first in github and configure it in Jenkins

[Generate a token in Github](https://docs.catalyst.zoho.com/en/tutorials/githubbot/java/generate-personal-access-token/)

Now, open Jenkins UI
  > Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
![image-21](https://github.com/user-attachments/assets/57f32901-42b1-415e-b2f7-8ea36930e8c1)

### <span style="color: cyan;"> [Generate docker Token](https://www.geeksforgeeks.org/create-and-manage-docker-access-tokens/) and update in Jenkins.</span>
  > Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)

- Configure the docker
> Name- docker
> [x] install automatically <br>
> docker version: latest
### <span style="color: cyan;"> Set docker cred in Jenkins </span>
-    Dashboard>Manage Jenkins > Credentials> System>
    Global credentials (unrestricted) &rArr; Click on "New credentials"
> kind: "username with password"
> username: your docker login ID
> password: docker token
> Id: docker-cred #it would be used in pipeline
> Description:docker-cred
![image-43](https://github.com/user-attachments/assets/2cc29020-85be-4591-8f52-b0f763d9bd45)
 -->


- **Image view from Docker Hub**:
![image-13](https://github.com/user-attachments/assets/c32352b2-be3a-4950-abdf-ba42a569ce45)

- **View from SonarQube:**
![image-12](https://github.com/user-attachments/assets/eeeca9d1-9931-4968-b6d4-3b3e682a00ed)

Congratulations! :-) You have deployed the application successfully.



### <span style="color: Yellow;"> Resources used in AWS:



- EC2 instances
![image-11](https://github.com/user-attachments/assets/4144c314-d9a0-4417-84fc-a40cc65bfb5b)

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

- To delete the ```Virtual machine```.
Go to folder *<span style="color: cyan;">"18.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion

In the Valentine’s Day DevOps CICD project, we combined various DevOps tools and practices to create a robust pipeline that ensures code quality, security, and seamless deployment. By leveraging Jenkins as our core CI/CD tool, we orchestrated several stages: source code retrieval, quality checks using SonarQube, security scans with Trivy, Docker image building and scanning, and deployment on a target environment. The project demonstrated effective integration of these tools and highlighted best practices in automation and container management.

This project offers a practical way to deepen one’s understanding of CI/CD pipelines, including essential components like automated testing, image scanning, and secure Docker deployment. Furthermore, the project’s Valentine’s Day theme adds an engaging, fun layer to the DevOps experience, making it a memorable learning journey. Whether for personal skill enhancement or as a showcase of DevOps competency, this project serves as a valuable template for building reliable and secure CI/CD pipelines.

References
For a deeper understanding and detailed steps on similar setups, feel free to check the following technical blogs:


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=_Xo3eYAz7Zo&t=1169s)

- [Docker Compose install](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
  
- [Application Repo](https://github.com/mrbalraj007/Valentine-Day-DevOps-Project.git)


