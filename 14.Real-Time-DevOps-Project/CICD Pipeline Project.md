# <span style="color: Yellow;"> Simple Notes App for Community: End-to-End Implementation using CI/CD" </span>
This project involves creating a Simple Notes App for a community, using CI/CD (Continuous Integration and Continuous Deployment) pipelines. Below is a detailed breakdown of the prerequisites, key takeaways, what to avoid, and the key benefits of using this approach."

## <span style="color: Yellow;"> Prerequisites </span>
Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo](https://github.com/mrbalraj007/django-notes-app.git)

- [x] __Basic Knowledge of GitHub__: You need to be familiar with version control, pull requests, and branching.
- [x] __Understanding of Docker__: Docker is used for containerizing the application. Make sure you know how to create, manage, and run Docker containers.
- [x] __Familiarity with Jenkins__: Jenkins is the CI tool that automates the testing and deployment process. A basic understanding of setting up Jenkins pipelines is essential.
- [x] __Experience with Python and Node.js__: Since the backend of the app is likely in Python and the frontend in React (which relies on Node.js), make sure you're comfortable with both technologies.
- [x] __React Framework__: This is used to build the user interface. Familiarity with React components, state management, and hooks is important.

## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform code to set up the entire environment, including the installation of required applications, and tools.

- &rArr; <span style="color: brown;">Two EC2 machine will be created named as "Jenkins Server & Agent"
- &rArr;<span style="color: brown;"> Docker Install

### <span style="color: Yellow;">Setting Up the Virtual Machines (EC2)

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
da---l          29/09/24  12:02 PM                k8s_setup_file
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          01/10/24  10:50 AM           3771 agent_install.sh
-a---l          01/10/24  10:59 AM           8149 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
-a---l          25/07/24   9:16 PM            239 provider.tf
-a---l          01/10/24  11:26 AM          10257 terrabox_install.sh
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

da---l          29/09/24  12:02 PM                k8s_setup_file
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          01/10/24  10:50 AM           3771 agent_install.sh
-a---l          01/10/24  10:59 AM           8149 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
-a---l          25/07/24   9:16 PM            239 provider.tf
-a---l          01/10/24  11:26 AM          10257 terrabox_install.sh
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
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files](13.Real-Time-DevOps-Project\cloud-init-output.log).
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
```
- If the user_data script runs successfully, you will see output logs and any errors encountered during execution.
- If there’s an error, this log will provide clues about what failed.

Outcome of "```cloud-init-output.log```"
![alt text](image.png)
![alt text](image-1.png)


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
- [x] <span style="color: brown;"> Helm version
```bash
ubuntu@ip-172-31-89-97:~$ helm version
version.BuildInfo{Version:"v3.16.1", GitCommit:"5a5449dc42be07001fd5771d56429132984ab3ab", GitTreeState:"clean", GoVersion:"go1.22.7"}
```
- [x] <span style="color: brown;"> Terraform version
```bash
ubuntu@ip-172-31-89-97:~$ terraform version
Terraform v1.9.6
on linux_amd64
```
- [x] <span style="color: brown;"> eksctl version
```bash
ubuntu@ip-172-31-89-97:~$ eksctl version
0.191.0
```
- [x] <span style="color: brown;"> kubectl version
```bash
ubuntu@ip-172-31-89-97:~$ kubectl version
Client Version: v1.31.1
Kustomize Version: v5.4.2
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

- [x] <span style="color: brown;"> Verify the EKS cluster

After Terraform deploys the instance and the cluster is set up, you can SSH into the instance and run:

```bash
aws eks update-kubeconfig --name <cluster-name> --region 
<region>
```

On the virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
```sh
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ pwd
/home/ubuntu/k8s_setup_file
ubuntu@ip-172-31-90-126:~/k8s_setup_file$
```
Once EKS cluster is setup then need to run the following command to make it intract with EKS.

```sh
aws eks update-kubeconfig --name balraj-cluster --region us-east-1
```
The ```aws eks update-kubeconfig``` command is used to configure your local kubectl tool to interact with an Amazon EKS (Elastic Kubernetes Service) cluster. It updates or creates a kubeconfig file that contains the necessary authentication information to allow kubectl to communicate with your specified EKS cluster.

<span style="color: Orange;"> What happens when you run this command:</span><br>
The AWS CLI retrieves the required connection information for the EKS cluster (such as the API server endpoint and certificate) and updates the kubeconfig file located at ~/.kube/config (by default).
It configures the authentication details needed to connect kubectl to your EKS cluster using IAM roles.
After running this command, you will be able to interact with your EKS cluster using kubectl commands, such as ```kubectl get nodes``` or ```kubectl get pods```.

```sh
kubectl get nodes
kubectl cluster-info
kubectl config get-contexts
```
![alt text](image-2.png)

<details><summary><b><span style="color: Orange;">Change the hostname: (optional)</b></summary><br>

sudo terraform show


```bash
sudo hostnamectl set-hostname jenkins-svr
sudo hostnamectl set-hostname jenkins-agent
```
- Update the /etc/hosts file:
  - Open the file with a text editor, for example:
```bash
sudo vi /etc/hosts
```
Replace the old hostname with the new one where it appears in the file.

Apply the new hostname without rebooting:
```bash
sudo systemctl restart systemd-logind.service
```
Verify the change:
```bash
hostnamectl
```

Update the package
```bash
sudo -i
apt update 
```
</details>

## <span style="color: yellow;"> Setup the Jenkins </span>
Access Jenkins via http://<your-server-ip>:8080. Retrieve the initial admin password using:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![alt text](image-5.png)
![alt text](image-6.png)


### <span style="color: yellow;"> Setup the Jenkins agent</span>
- [Set the password](https://www.cyberciti.biz/faq/change-root-password-ubuntu-linux/) for user "ubuntu" on both Jenkins Master and Agent machines.
```sh
sudo passwd ubuntu
```  
  ![alt text](image-3.png)

- Need to do the password-less authentication between both servers.
```bash
sudo su
cat /etc/ssh/sshd_config | grep "PasswordAuthentication"
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep "PasswordAuthentication"

cat /etc/ssh/sshd_config | grep "PermitRootLogin"
echo "PermitRootLogin yes"  >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep "PermitRootLogin"
```
- Restart the sshd reservices.<br>
```bash
systemctl daemon-reload
      or 
sudo service ssh restart 
```
- Generate the ssh key and share with agent.
```bash
ssh-keygen
```
- Copy the public ssh key from Jenkins to Agent.
    - Public key from Jenkins master.
```bash
ubuntu@ip-172-31-89-97:~$ cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4BFDIh47LkE6huSzi6ryMKcw+Rj1+6ErnplFbOK5Nz ubuntu@ip-172-31-89-97
```
From Agent.
![alt text](image-4.png)

Now, try to do the ssh to agent, and it should be connected without any credentials.
```bash
ssh ubuntu@<private IP address of agent VM>
```
![alt text](image-7.png)

Open Jenkins UI and configure the agent.
Dashboard> Manage Jenkins> Nodes

Remote root directory: define the path.
Launch method: Launch agents via ssh
- Host: public IP address of agent VM
- Credential of the agent. (will create the credential)
    - Kind: SSH Username with private key
    - private key from Jenkins Master server.
  ![alt text](image-10.png)
- Host Key Verification Strategy: Non Verifying Verification Strategy

![alt text](image-8.png)

![alt text](image-9.png)
![alt text](image-11.png)

Congratulations; Agent is successfully configured and alive.
![alt text](image-12.png)

### <span style="color: cyan;"> Install the plugin in Jenkins </span>

```sh
Blue Ocean
Pipeline: Stage View
```

- Run any job and verify that job is executing on agent node.
   - create a below pipeline and build it and verify the outcomes in agent machine.
```bash
pipeline {
    agent { label "balraj"}

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/django-notes-app.git'
                echo "This is cloning the code"
            }
        }
    }
}
```
![alt text](image-13.png)

- Build an Docker image.
add the following state in main pipeline
 ```sh
          stage('build') {
            steps {
                echo 'This is building the docker image'
                sh "docker build -t notes-app:latest ."
                echo "Image has been created successfully"
            }
        }
```
![alt text](image-14.png)

- Add the below the deploy the image.
```sh
 stage('test') {
            steps {
                echo 'This is testing the code'
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is deploying the code'
                sh 'docker run -d -p 8000:8000 notes-app:latest '
            }
        }
```
![alt text](image-15.png)

```bash
pipeline {
    agent { label "balraj"}

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/django-notes-app.git'
                echo "This is cloning the code"
            }
        }
        stage('build') {
            steps {
                echo 'This is building the docker image'
                sh "docker build -t notes-app:latest ."
                echo "Image has been created successfully"
            }
        }
        stage('test') {
            steps {
                echo 'This is testing the code'
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is deploying the code'
                sh 'docker run -d -p 8000:8000 notes-app:latest '
            }
        }
    }
}
```
Now, try to access it via 8000 port
<agent Public Ipaddress:8000>
![alt text](image-16.png)

If you rerun the build, then you will get an error because port 8000 has already been used. So we will use here Docker Compose.

![alt text](image-17.png)

here is the updated pipeline
```bash
pipeline {
    agent { label "balraj"}

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/django-notes-app.git'
                echo "This is cloning the code"
            }
        }
        stage('build') {
            steps {
                echo 'This is building the docker image'
                sh "docker build -t notes-app:latest ."
                echo "Image has been created successfully"
            }
        }
        stage('test') {
            steps {
                echo 'This is testing the code'
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is deploying the code'
                sh 'docker compose up -d'
            }
        }
    }
}
```
Kill the existing image/deployment before build/executing it.
```bash
docker container ls
docker stop aa48f961a5de && docker rm aa48f961a5de
```
![alt text](image-18.png)
![alt text](image-19.png)

- Push image to Docker hub.
   - create crdential in Jenkins for Dockerhub
![alt text](image-20.png)

- bind credential in pipeline
```bash
pipeline {
    agent { label "balraj"}

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/django-notes-app.git'
                echo "This is cloning the code"
            }
        }
        stage('build') {
            steps {
                echo 'This is building the docker image'
                sh "docker build -t notes-app:latest ."
                echo "Image has been created successfully"
            }
        }
        stage('test') {
            steps {
                echo 'This is testing the code'
            }
        }
        stage('Push to DockerHub') {
            steps {
                echo "This is pushing image to Docker Hub"
                withCredentials([usernamePassword(credentialsId:"dockerHubCred",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker image tag notes-app:latest ${env.dockerHubUser}/notes-app:latest"
                sh "docker push ${env.dockerHubUser}/notes-app:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is deploying the code'
                sh 'docker compose up -d'
            }
        }
    }
}
```
![alt text](image-21.png)

- Creating a [webhook](https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks) for Jenkins in Github
- Go to repo setting and click on webhooks
  PayloadURL: http://54.144.163.163:8080/github-webhook/   (Jenkins URL with port)
- Content type: Application/Json
![alt text](image-22.png)

I was getting a 302 error message, and when I followed the below procedure, it fixed itself.
I clicked on webhooks and clicked on the recent deliveries and clicked on redeliver and issue fixed.
![alt text](image-23.png)
![alt text](image-24.png)

Now, we have to tick this option in Jenkins: "GitHub hook trigger for GITScm polling."
![alt text](image-25.png)

Try to modify anything in Github repo and build should be auto trigger.

![alt text](image-26.png)

it works :-)


![image](https://github.com/user-attachments/assets/bb628a4f-36be-4af9-998f-2165fb837046)
![image-1](https://github.com/user-attachments/assets/cd0b6335-681c-4773-b233-325efbaa7ac1)
![image-2](https://github.com/user-attachments/assets/d029f649-81e9-4750-a6c4-8e636c104e16)
![image-3](https://github.com/user-attachments/assets/57fae1e1-7dbc-4b0f-877e-0266c83af6bc)
![image-4](https://github.com/user-attachments/assets/5ac10b8d-2ef1-426e-9e0c-6971cfb4f03a)
![image-5](https://github.com/user-attachments/assets/4f51816f-190a-4a43-a7a1-e6a93a1bedb0)
![image-6](https://github.com/user-attachments/assets/d2c70de6-debc-4bec-9208-b36f0b308a32)
![image-7](https://github.com/user-attachments/assets/475ddd3a-fb0c-40ce-857d-af6cfbef0a08)
![image-8](https://github.com/user-attachments/assets/ece7e0e6-d398-42ae-8d90-45d8bd9445e9)
![image-9](https://github.com/user-attachments/assets/6b865751-770d-45e4-a991-9d82feb0a44d)
![image-10](https://github.com/user-attachments/assets/35a4974d-9447-4b7a-b074-4151e4691708)
![image-11](https://github.com/user-attachments/assets/b276a604-bc28-432b-a8cd-51ce6062e024)
![image-12](https://github.com/user-attachments/assets/4bf6a9fc-5579-4ce5-bfe4-2eedef303579)
![image-13](https://github.com/user-attachments/assets/6671ba4f-690e-47f6-be6a-217a7fe2ede8)
![image-14](https://github.com/user-attachments/assets/64d2b951-5a58-4ab0-b471-e6cd6b5559fd)
![image-15](https://github.com/user-attachments/assets/f7f25d1c-187c-4271-a37a-211c9a95c895)
![image-16](https://github.com/user-attachments/assets/a4aa43ba-163a-4c63-97ed-326d3dd19373)
![image-17](https://github.com/user-attachments/assets/b76a7f1e-ec81-44ad-8c7a-6dd8f869969f)
![image-18](https://github.com/user-attachments/assets/2f44ca33-9edc-4c2c-8ae8-456b2c9b725e)
![image-19](https://github.com/user-attachments/assets/cb3c2969-9844-45ca-9cd7-2d121e614b49)
![image-20](https://github.com/user-attachments/assets/e7ec7dd7-45d8-45fc-beef-7cabef19a6e5)
![image-21](https://github.com/user-attachments/assets/8e5ecc07-77b3-410d-b3c2-e10f2686d901)
![image-22](https://github.com/user-attachments/assets/688e5d89-da8a-4a6d-8877-6e3f675625aa)
![image-23](https://github.com/user-attachments/assets/2191c55c-6693-4663-88d4-ce5110329c22)
![image-24](https://github.com/user-attachments/assets/a12e92f4-9650-4d62-8a3e-6c9f525899b7)
![image-25](https://github.com/user-attachments/assets/ca734da6-ef5a-454b-a516-9b0c9dcff4d2)
![image-26](https://github.com/user-attachments/assets/514af65a-448f-462b-8a57-b9afd0a875de)

__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=XaSdKR2fOU4&t=21621s "DevOps Production CICD Pipelines")
