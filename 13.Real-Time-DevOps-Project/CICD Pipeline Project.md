# <span style="color: Yellow;"> Building a Three-Tier Blogging App with DevSecOps: The **WanderLust** Mega Project </span>
"WanderLust is a travel blog web application developed using the ```MERN stack (MongoDB, Express.js, React, and Node.js)```. This project is designed to foster open-source contributions, enhance React development skills, and provide hands-on experience with Git."

## <span style="color: Yellow;"> Prerequisites </span>
Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from k8s_setup_file/main.tf (i.e ```balraj```*).
  - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo](https://github.com/mrbalraj007/Wanderlust-Mega-Project.git)

- [x] __Git and GitHub__: You'll need to know the basics of Git for version control and GitHub for managing your repository.
- [x] __MERN Stack (MongoDB, Express, React, Node.js)__: A solid understanding of React for front-end development and how it integrates with MongoDB, Express, and Node.js is essential.
- [x] __Docker__: Familiarity with containerization using Docker to package the application and its dependencies.
- [x] __Jenkins__: Understanding continuous integration (CI) and how to set up Jenkins for automating the build and test processes.
- [x] __Kubernetes (AWS EKS)__: Some experience with deploying and managing containerized applications using Kubernetes, especially with Amazon EKS.
- [x] __Helm__: Helm charts knowledge is required for deploying applications on Kubernetes, particularly for monitoring with tools like Prometheus and Grafana.
- [x] __Security Tools__: OWASP Dependency Check for identifying vulnerabilities, SonarQube for code quality analysis, and Trivy for scanning Docker images.
- [x] __ArgoCD__: Familiarity with ArgoCD for continuous delivery (CD) to manage the Kubernetes application deployment.
- [x] __Redis__: Basic knowledge of Redis for caching to improve application performance.

## <span style="color: Yellow;"> Key Points
- GitHub – for code version control and collaboration
- Docker – for containerizing applications
- Jenkins – for continuous integration (CI)
- OWASP Dependency-Check – for identifying vulnerable dependencies
- SonarQube – for code quality and security analysis
- Trivy – for filesystem scanning and security checks
- ArgoCD – for continuous deployment (CD)
- Redis – for caching services
- AWS EKS – for managing Kubernetes clusters
- Helm – for managing monitoring tools like Prometheus and Grafana

## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform code to set up the entire environment, including the installation of required applications, tools, and the EKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> EKS cluster creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: brown;">Two EC2 machines will be created named as "Jenkins Server & Agent"
- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Trivy Install
- &rArr;<span style="color: brown;"> Helm Install
- &rArr;<span style="color: brown;"> SonarQube install as in a container
- &rArr;<span style="color: brown;"> ArgoCD
- &rArr;<span style="color: brown;"> EKS Cluster Setup
- &rArr;<span style="color: brown;"> Prometheus install using Helm
- &rArr;<span style="color: brown;"> Grafana install using Helm

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

![image-14](https://github.com/user-attachments/assets/2178b2cb-52b5-4080-88bd-1dc49d97f309)


Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```Cloud-Init``` logs</span>: 
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/13.Real-Time-DevOps-Project/cloud-init-output.log).
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
```
- If the user_data script runs successfully, you will see output logs and any errors encountered during execution.
- If there’s an error, this log will provide clues about what failed.

Outcome of "```cloud-init-output.log```"
![image](https://github.com/user-attachments/assets/cf3ccb19-be9f-4bb4-aa61-1e65287ad1b9)
![image-1](https://github.com/user-attachments/assets/7c4ad4a6-4882-4d48-90f3-2eac2fe65aad)


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

On the virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
```sh
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ pwd
/home/ubuntu/k8s_setup_file
ubuntu@ip-172-31-90-126:~/k8s_setup_file$
```

After Terraform deploys the instance and the cluster is set up, you can SSH into the instance and run:

```bash
aws eks update-kubeconfig --name <cluster-name> --region 
<region>
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
![image-2](https://github.com/user-attachments/assets/e6afb5c4-9a16-45f6-9d06-fe9fcf19761b)

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
![image-5](https://github.com/user-attachments/assets/72a2d1c3-d62b-4d1f-bedc-c6677f2f4efd)
![image-6](https://github.com/user-attachments/assets/d448fd1b-ae89-4540-b486-9a35f24b76dd)


### <span style="color: yellow;"> Setup the Jenkins agent</span>
- [Set the password](https://www.cyberciti.biz/faq/change-root-password-ubuntu-linux/) for user "ubuntu" on both Jenkins Master and Agent machines.
```sh
sudo passwd ubuntu
```  
![image-3](https://github.com/user-attachments/assets/478fa108-42ab-4692-bb4c-f976fb3eab21)

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
![image-4](https://github.com/user-attachments/assets/c0a17dfe-f269-4b5e-94e9-e0faf3811493)

Now, try to do the ssh to agent, and it should be connected without any credentials.
```bash
ssh ubuntu@<private IP address of agent VM>
```
![image-7](https://github.com/user-attachments/assets/df183ecc-e83b-4227-8ec6-588a153c9b66)

Open ```Jenkins UI ```and configure the agent. <br>
Dashboard> Manage Jenkins> Nodes

Remote root directory: define the path where folder would be created.
Launch method: Launch agents via ssh
- Host: public IP address of agent VM
- Credential of the agent. (will create the credential)
    - Kind: SSH Username with private key
    - private key from Jenkins Master server.
      ![image-10](https://github.com/user-attachments/assets/bd69d0e9-882e-4e97-8a68-2c051e1e1d8a)
- Host Key Verification Strategy: Non Verifying Verification Strategy

![image-8](https://github.com/user-attachments/assets/7538787b-ae2a-4e72-846f-7cb8ea655710)
![image-9](https://github.com/user-attachments/assets/bbf9d2c3-97af-44bb-abe2-8844463d6bca)
![image-11](https://github.com/user-attachments/assets/20cfaef4-560a-4ab8-8063-022c5bccf290)

**Congratulations**; Agent is successfully configured and alive. :-)

![image-12](https://github.com/user-attachments/assets/07748e09-e45e-4f1d-9d43-22d6750524e4)

### <span style="color: cyan;"> Install the plugin in Jenkins </span>
Manage Jenkins > Plugins view> Under the Available tab, plugins available for download from the configured Update Center can be searched and considered:

```sh
Blue Ocean
Pipeline: Stage View
Docker
Docker Pipeline
Kubernetes
Kubernetes CLI
OWASP Dependency-Check
SonarQube Scanner
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
![image-13](https://github.com/user-attachments/assets/32e8d38f-dacc-4570-8643-322b298737c9)

## <span style="color: yellow;">Jenkins Shared Library
- Shared libraries in Jenkins Pipelines are reusable pieces of code that can be organized into functions and classes.
- These libraries allow you to encapsulate common logic, making it easier to maintain and share across multiple pipelines and projects.
- Shared library must be inside the **vars** directory in your github repository
- Shared library uses **groovy** syntax and file name ends with **.groovy** extension. 


### <span style="color: cyan;">How to create and use shared library in Jenkins.

#### How to create Shared library
- Login to your Jenkins dashboard. <a href="">Jenkins Installation</a>
- Go to **Manage Jenkins** --> **System** and search for **Global Trusted Pipeline Libraries**.
![image-48](https://github.com/user-attachments/assets/9d0e6c2f-99cf-43e7-ae1a-d097d8245018)


  **Name:** Shared <br>
  **Default version:** \<branch name><br>
  **Project repository:** https://github.com/mrbalraj007/Jenkins_SharedLib.git <br>
![image-49](https://github.com/user-attachments/assets/04b0e8ac-4964-4e3c-8757-87187309b1f5)
![image-50](https://github.com/user-attachments/assets/a32e63e2-f992-4a61-90fc-ade1e9e146ce)

#### How to use it in Jenkins pipeline
- Go to your declarative pipeline
- Add **@Library('Shared') _** at the very first line of your jenkins pipeline.
![image-58](https://github.com/user-attachments/assets/4955ffab-cbab-42df-b822-dfdd03c0336a)

**Note:** @Library() _ is the syntax to use shared library.


### <span style="color: cyan;"> Configure SonarQube </span>

<public IP address: 9000>

![image-15](https://github.com/user-attachments/assets/ab812f25-e5ec-4346-a4b6-967883a343a2)
  default login : admin/admin <br>
  You have to change password as per below screenshot
![image-16](https://github.com/user-attachments/assets/f35e952a-249a-4788-b9d4-fbaa1348f5ca)

### <span style="color: cyan;"> Configure email:</span>
Open a Jenkins UI and go to 
    Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted) <br>

![image-17](https://github.com/user-attachments/assets/6d87f8a3-ac4b-4e08-863a-db7af794396b)

##### <span style="color: cyan;">Configure email notification </span>
    Dashboard> Manage Jenkins> System
Search for "```Extended E-mail Notification```"

![image-18](https://github.com/user-attachments/assets/b7090f49-f40c-4994-9260-83f87841d15a)
![image-19](https://github.com/user-attachments/assets/03d1a791-7bfc-4078-8852-5f1aaf6dc8a3)
![image-20](https://github.com/user-attachments/assets/e180f343-8884-44b1-a4b5-ab50e5d8bddd)


Open Gmail ID and have look for notification email:
![image-21](https://github.com/user-attachments/assets/7c79a48a-9304-44c7-95ff-4967b93cfd78)

### <span style="color: cyan;"> Configure OWASP:</span>
Dashboard
Manage Jenkins
Tools

search for ```Dependency-Check installations ```
![image-22](https://github.com/user-attachments/assets/2db469b4-d5cd-4b4a-94f8-e10367283df9)
![image-23](https://github.com/user-attachments/assets/d8e0c4aa-5eba-42fc-866c-9b9efd07aecd)

### <span style="color: cyan;"> Integrate SonarQube in Jenkins.</span>
Go to Sonarqube and generate the token

> Administration> Security> users>

![image-24](https://github.com/user-attachments/assets/30d99980-a369-4409-bb73-14b943fbfe14)
![image-25](https://github.com/user-attachments/assets/3b4d4339-2e5c-4fb4-916b-05259ff52100)
![image-26](https://github.com/user-attachments/assets/8d8e4a99-6de7-452f-af08-e32a70d129b3)

now, open Jenkins UI and create a credential for sonarqube

> Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)

![image-27](https://github.com/user-attachments/assets/9dc502f1-fa13-4e79-b209-1fa669dc53ab)

#### <span style="color: cyan;"> Configure the sonarqube scanner in Jenkins.</span>
> Dashboard> Manage Jenkins> Tools

Search for ```SonarQube Scanner installations``` 

![image-28](https://github.com/user-attachments/assets/a6eb21a9-c5e9-4e3d-89c5-da58a5b5cfa2)
![image-29](https://github.com/user-attachments/assets/51ced903-061b-409d-ae05-867f24dc2253)

#### <span style="color: cyan;"> Configure the Github in Jenkins.</span>
First generate the token first in github and configure it in Jenkins

[Generate a token in Github](https://docs.catalyst.zoho.com/en/tutorials/githubbot/java/generate-personal-access-token/)

Now, open Jenkins UI
  > Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)

![image-30](https://github.com/user-attachments/assets/b5df0219-7925-448c-84b2-5b3c92ded7c7)


#### <span style="color: cyan;"> Configure the sonarqube server in Jenkins.</span>
On Jenkins UI:
  > Dashboard> Manage Jenkins> System > Search for ```SonarQube installations``` 
![image-31](https://github.com/user-attachments/assets/b3f27eb2-a87c-4e9f-8472-ae7f638cd86a)
![image-32](https://github.com/user-attachments/assets/1cb62ce5-d282-454e-a7ef-c139e5e89a41)

Now, we will confire the ```webhook``` in Sonarqube
Open SonarQube UI:

![image-33](https://github.com/user-attachments/assets/723238a3-0263-46a8-939b-c7bf96e24cdb)
![image-34](https://github.com/user-attachments/assets/b45774d9-a8e8-42b5-bdf3-b922864edc15)

### <span style="color: cyan;"> [Generate docker Token](https://www.geeksforgeeks.org/create-and-manage-docker-access-tokens/) and update in Jenkins.</span>
  > Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)

- Configure the docker
> Name- docker
> [x] install automatically
> docker version: latest
### <span style="color: cyan;"> Set docker cred in Jenkins </span>
-    Dashboard>Manage Jenkins > Credentials> System>
    Global credentials (unrestricted) &rArr; Click on "New credentials"
> kind: "username with password"
> username: your docker login ID
> password: docker token
> Id: docker-cred #it would be used in pipeline
> Description:docker-cred
![image-51](https://github.com/user-attachments/assets/fab143ab-7f19-48c4-8e4e-d83c3c155318)

### <span style="color: cyan;"> Configure the ArgoCD.</span>
- Get a argocd namespace
```bash
kubectl get namespace
```
![image-35](https://github.com/user-attachments/assets/a98d58fd-450b-483c-a67a-bc3dfcd22234)

- Get the argocd pods
```bash
kubectl get pods -n argocd
```
![image-36](https://github.com/user-attachments/assets/39fa9c36-452c-4269-9c75-7f901bd62a0e)

- Check argocd services
```bash
kubectl get svc -n argocd
```
![image-37](https://github.com/user-attachments/assets/2514c953-495d-4a6e-9022-21cb63cd73ca)

**Change argocd server's service from ClusterIP to NodePort**
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n argocd
```
![image-38](https://github.com/user-attachments/assets/b5206012-e59c-4fe4-a064-0be210fc945a)

Now, try to access ArgoCd in browser.
<public-ip-worker>:<port>
![image-41](https://github.com/user-attachments/assets/27386486-cc2b-42c3-86bd-24dd6a010184)

**Note**: I was not able to access argocd in browser and noticed that port was not allowed.
You need to select any of the EKS cluster node and go to security group
Select the SG "sg-0838bf9c407b4b3e4" (You need to select yours one) and allow the all port range.

![image-39](https://github.com/user-attachments/assets/6f67913d-9c26-4211-9e12-3a48cfc2a77a)

Now, try to access ArgoCd in browser.
![image-40](https://github.com/user-attachments/assets/92687012-ec81-42fc-bd44-98b03743d477)

```bash
https://<IP address>:31230
```

```bash
https://44.192.109.76:31230/
```
Default login would be admin/admin
- To get the initial password of argocd server
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![image-42](https://github.com/user-attachments/assets/83c4015d-e2ba-49df-a63f-fb8d6e76bdf3)
![image-43](https://github.com/user-attachments/assets/dfa4c0ae-7718-4f34-b1bb-e62bfdfc0a3e)

Update the password for argocd
![image-44](https://github.com/user-attachments/assets/f1bfeb23-2826-469c-b8a4-770e20deb043)


### <span style="color: cyan;"> Configure the repositories in Argocd </span>
![image-45](https://github.com/user-attachments/assets/e847c940-cba6-4c66-a3f3-e53c1e9f48c9)

[Application Repo](https://github.com/mrbalraj007/Wanderlust-Mega-Project.git)

![image-46](https://github.com/user-attachments/assets/9fff6e2b-7368-48f8-8308-34666a1a6dd0)
![image-47](https://github.com/user-attachments/assets/ff3fd254-ae42-4fdb-a715-a927b6c447eb)

### <span style="color: Cyan;"> For CI Pipeline
Update this [jenkins file](https://github.com/mrbalraj007/Wanderlust-Mega-Project/blob/main/Jenkinsfile) as per your requirement.

Go to folder ```Wanderlust-Mega-Project``` and copy the Jenkins pipeline from git repo and build a pipeline named as ```Wanderlust-CI```.

Make sure, you will change the following details before change it.
```sh
- label
- git repo
- Docker image tag
```
Complete pipeline
```bash
@Library('Shared') _
pipeline {
    agent {label 'Balraj'}
    
    environment{
        SONAR_HOME = tool "Sonar"
    }
    
    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }
    
    stages {
        stage("Validate Parameters") {
            steps {
                script {
                    if (params.FRONTEND_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == '') {
                        error("FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided.")
                    }
                }
            }
        }
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    code_checkout("https://github.com/mrbalraj007/Wanderlust-Mega-Project.git","main")
                }
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar","wanderlust","wanderlust")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }
        
        stage('Exporting environment variables') {
            parallel{
                stage("Backend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }
                
                stage("Frontend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    }
                }
            }
        }
        
        stage("Docker: Build Images"){
            steps{
                script{
                        dir('backend'){
                            docker_build("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","balrajsi")
                        }
                    
                        dir('frontend'){
                            docker_build("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","balrajsi")
                        }
                }
            }
        }
        
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    docker_push("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","balrajsi") 
                    docker_push("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","balrajsi")
                }
            }
        }
    }
    post{
        success{
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
        }
    }
}
```


#### <span style="color: Cyan;"> ```Update Instnace ID``` in Automations folder
Go to folder ```Automations``` and update the instance ID in both bash scripts. Instance ID would be EC2 EKS instance.

- Automations/updatebackendnew.sh
![image-97](https://github.com/user-attachments/assets/272a6dfc-9e67-4ff0-a620-6c6770ac3f05)

- Automations/updatefrontendnew.sh
![image-98](https://github.com/user-attachments/assets/0ef1416a-9067-443d-a048-a951cfbedd09)

<details><summary><b><span style="color: Red;"> Troubleshooting while run CI Pipeline </span></b></summary><br>

I was getting an error while running the CI job first time because due to missing required environment variables: ```FRONTEND_DOCKER_TAG``` and ```BACKEND_DOCKER_TAG```. 

Steps to Fix
Ensure Required Parameters Are Provided:

[!Important]
First time, when you run the pipeline, then the pipeline will fail because the parameter is not given. Try a second time and pass the parameter.

![image-52](https://github.com/user-attachments/assets/8baef4d1-a1dc-4bbd-855f-4aef31ffef4a)
![image-54](https://github.com/user-attachments/assets/45fe49cf-22e9-4369-9d65-cc7f27e9c2ee)

[!Note]
When I ran it again and got the below error message saying that Trivy was not found, I noticed that Trivy didn't install on the Jenkins agent machine. So, I have updated the Terraform script, and the pipeline should work.

![image-55](https://github.com/user-attachments/assets/ef2238b8-befb-44a5-bb99-7fe1d275adf3)

Now, I got below error message "permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?". I have updated the Terraform script.

![image-56](https://github.com/user-attachments/assets/152a3cd6-d8de-4767-9353-e56ad904d88e)

Solution:  
```bash
sudo usermod -aG docker $USER && newgrp docker
```
![image-57](https://github.com/user-attachments/assets/c9a07ab5-df76-4ee0-b6db-c7c648f3d590)

But I was still getting same error message to fix the issue.
![image-57](https://github.com/user-attachments/assets/c9a07ab5-df76-4ee0-b6db-c7c648f3d590)

Solution:  
```bash
sudo systemctl restart jenkins
```
![image-61](https://github.com/user-attachments/assets/bfa8c204-7813-4818-8e10-2322ec6100b2)
![image-60](https://github.com/user-attachments/assets/83626827-311e-4699-98af-78db465d73ef)
</details>

### <span style="color: Cyan;"> For CD Pipeline

Go to folder ```Gitops``` and copy the Jenkins pipeline from git repo and build a pipeline named as ```Wanderlust-CD```.

make sure, you will change the following details before change it.
```sh
- git repo
- email adddress
```
Complete pipeline
```sh
@Library('Shared') _
pipeline {
    agent {label 'Balraj'}
    
    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Frontend Docker tag of the image built by the CI job')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Backend Docker tag of the image built by the CI job')
    }

    stages {
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    code_checkout("https://github.com/mrbalraj007/Wanderlust-Mega-Project.git","main")
                }
            }
        }
        
        stage('Verify: Docker Image Tags') {
            steps {
                script{
                    echo "FRONTEND_DOCKER_TAG: ${params.FRONTEND_DOCKER_TAG}"
                    echo "BACKEND_DOCKER_TAG: ${params.BACKEND_DOCKER_TAG}"
                }
            }
        }
        
        
        stage("Update: Kubernetes manifests"){
            steps{
                script{
                    dir('kubernetes'){
                        sh """
                            sed -i -e s/wanderlust-backend-beta.*/wanderlust-backend-beta:${params.BACKEND_DOCKER_TAG}/g backend.yaml
                        """
                    }
                    
                    dir('kubernetes'){
                        sh """
                            sed -i -e s/wanderlust-frontend-beta.*/wanderlust-frontend-beta:${params.FRONTEND_DOCKER_TAG}/g frontend.yaml
                        """
                    }
                    
                }
            }
        }
        
        stage("Git: Code update and push to GitHub"){
            steps{
                script{
                    withCredentials([gitUsernamePassword(credentialsId: 'Github-cred', gitToolName: 'Default')]) {
                        sh '''
                        echo "Checking repository status: "
                        git status
                    
                        echo "Adding changes to git: "
                        git add .
                        
                        echo "Commiting changes: "
                        git commit -m "Updated environment variables"
                        
                        echo "Pushing changes to github: "
                        git push https://github.com/mrbalraj007/Wanderlust-Mega-Project.git main
                    '''
                    }
                }
            }
        }
    }
  post {
        success {
            script {
                emailext attachLog: true,
                from: 'raj10ace@gmail.com',
                subject: "Wanderlust Application has been updated and deployed - '${currentBuild.result}'",
                body: """
                    <html>
                    <body>
                        <div style="background-color: #FFA07A; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Project: ${env.JOB_NAME}</p>
                        </div>
                        <div style="background-color: #90EE90; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
                        </div>
                        <div style="background-color: #87CEEB; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">URL: ${env.BUILD_URL}</p>
                        </div>
                    </body>
                    </html>
            """,
            to: 'raj10ace@gmail.com',
            mimeType: 'text/html'
            }
        }
      failure {
            script {
                emailext attachLog: true,
                from: 'raj10ace@gmail.com',
                subject: "Wanderlust Application build failed - '${currentBuild.result}'",
                body: """
                    <html>
                    <body>
                        <div style="background-color: #FFA07A; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Project: ${env.JOB_NAME}</p>
                        </div>
                        <div style="background-color: #90EE90; padding: 10px; margin-bottom: 10px;">
                            <p style="color: black; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
                        </div>
                    </body>
                    </html>
            """,
            to: 'raj10ace@gmail.com',
            mimeType: 'text/html'
            }
        }
    }
}
```

Now, run the ```Wanderlust-CI``` pipeline

When you run the next pipeline, then it will ask you to supply the tag version ```v6```.

![image-84](https://github.com/user-attachments/assets/0591dd37-abf2-4e5f-9f16-21eed0336f1a)

![image-91](https://github.com/user-attachments/assets/8d9759ea-0910-41f8-9f0b-08f6c66579d3)
![image-89](https://github.com/user-attachments/assets/c97c2489-b5a3-4469-a185-e59dcdb49e19)
![image-63](https://github.com/user-attachments/assets/50d1bb9a-8bdd-4b78-a6bf-92f518986dd2)
![image-86](https://github.com/user-attachments/assets/4f7a5054-3424-436e-bf42-8fbe9e28b1d6)
![image-90](https://github.com/user-attachments/assets/42c3a897-ed51-41d8-8234-15685f0ba5ca)

- Got email for successful deployment
![image-62](https://github.com/user-attachments/assets/5a7498ae-70fd-4d23-a792-68ce624519d3)

### <span style="color: Cyan;"> Connect ```wonderlast cluster``` to ArgoCD.
Now, we will connect(create) the cluster to ArgoCD.

on Jenkins Master Node, run the following command 
```sh
 kubectl get nodes
NAME                         STATUS   ROLES    AGE     VERSION
ip-10-0-1-239.ec2.internal   Ready    <none>   3h48m   v1.30.4-eks-a737599
ip-10-0-2-128.ec2.internal   Ready    <none>   3h47m   v1.30.4-eks-a737599
ip-10-0-2-92.ec2.internal    Ready    <none>   3h48m   v1.30.4-eks-a737599
ubuntu@ip-172-31-95-57:~$
```
#### <span style="color: Cyan;"> ArgoCD CLI login
```bash
argocd login argocd URL:port --username admin
```
- in myLab.
```bash
argocd login 44.192.109.76:31230 --username admin
```
will promt for yes/No , type y and supply the password for argocd.
![image-64](https://github.com/user-attachments/assets/a2834b21-ef09-43b0-ae74-c57c1aa10fbc)

- now, we will check the how many cluster have in argocd.
```bash
argocd cluster list
```
![image-65](https://github.com/user-attachments/assets/7ca9c126-1baa-4fd0-bfd7-33465db0a7b5)

- To get the wonderlust cluster name
```bash
kubectl config get-contexts
```
```bash
ubuntu@ip-172-31-95-57:~$ kubectl config get-contexts
CURRENT   NAME                                                        CLUSTER                                                     AUTHINFO                                                    NAMESPACE
*         arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster   arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster   arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster
ubuntu@ip-172-31-95-57:~$
```
- To add the wonderlust cluster name into argocd
```bash
argocd cluster add <your existing cluster name> --name <new cluster name>
```
```bash
argocd cluster add arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster --name wonderlust-eks-cluster
```
It will ask you to type Yes/No... type ```y```.

```bash
ubuntu@ip-172-31-95-57:~$ argocd cluster add arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster --name wonderlust-eks-cluster
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `arn:aws:eks:us-east-1:373160674113:cluster/balraj-cluster` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0010] ServiceAccount "argocd-manager" created in namespace "kube-system"
INFO[0010] ClusterRole "argocd-manager-role" created
INFO[0010] ClusterRoleBinding "argocd-manager-role-binding" created
INFO[0015] Created bearer token secret for ServiceAccount "argocd-manager"
Cluster 'https://9B7F2E2AB5BAFB3C44524B0AEA69BA1E.gr7.us-east-1.eks.amazonaws.com' added
ubuntu@ip-172-31-95-57:~$
```
it will create a namespace, roles (RBAC),service and token.

- Now, check how many cluster is showing 
```bash
ubuntu@ip-172-31-95-57:~$ argocd cluster list
SERVER                                                                    NAME                    VERSION  STATUS   MESSAGE                                                  PROJECT
https://9B7F2E2AB5BAFB3C44524B0AEA69BA1E.gr7.us-east-1.eks.amazonaws.com  wonderlust-eks-cluster           Unknown  Cluster has no applications and is not being monitored.
https://kubernetes.default.svc                                            in-cluster                       Unknown  Cluster has no applications and is not being monitored.
ubuntu@ip-172-31-95-57:~$
```
Now, go to ```argocd``` UI and refresh the page and you will see two cluster.

![image-66](https://github.com/user-attachments/assets/bd005f2e-e744-492e-82aa-440027c618c4)
![image-67](https://github.com/user-attachments/assets/fa6538d4-184c-4274-8860-33f65231c637)

### <span style="color: Cyan;"> Deploy application through argocd.

- Now, we will add the application first.

![image-68](https://github.com/user-attachments/assets/9e754b40-7930-4b13-8eff-79ca398f9bb7)
![image-69](https://github.com/user-attachments/assets/4ca6caa8-6504-4072-9126-9129ebc3e5f9)
![image-70](https://github.com/user-attachments/assets/86f8716c-99b1-4726-8578-02c8c7bd5f73)

- Health of the application
![image-71](https://github.com/user-attachments/assets/18b30b65-071e-4325-968f-5c06ef6abf3a)
![image-72](https://github.com/user-attachments/assets/9865cef3-bd95-485e-a9f9-7bbef3e5b507)

### <span style="color: Cyan;"> Verify application.
- Now, time to acces the application 
```bash
<worker-public-ip>:31000
```
![image-73](https://github.com/user-attachments/assets/91821346-7de8-42f0-9291-7186fa6327bf)
![image-74](https://github.com/user-attachments/assets/92483591-4dba-40cc-b288-36e03c5d1209)
![image-94](https://github.com/user-attachments/assets/8d2b97a1-548a-4c92-bab0-54af1e6746b3)
![image-95](https://github.com/user-attachments/assets/e2b803ef-a96e-453c-b172-8d9584038786)

Congratulations! :-) You have deployed the application successfully.

### <span style="color: Yellow;"> Status in Sonarqube
![image-87](https://github.com/user-attachments/assets/7d83ac6e-f80a-417e-82dc-701505487181)
![image-88](https://github.com/user-attachments/assets/068c904d-b517-401e-b3c7-692b203d83c2)

### <span style="color: Yellow;"> Image status in DockerHub
![image-59](https://github.com/user-attachments/assets/4e785490-5537-458e-9b9d-5bbe9d4194cd)

### <span style="color: Yellow;"> Configure observability (Monitoring)

#### <span style="color: Cyan;">List all Kubernetes pods in all namespaces:</span>
```sh
kubectl get pods -A
```
- To get the existing namespace 
```sh
kubectl get namespace
```
![image-93](https://github.com/user-attachments/assets/de8c9b60-01c8-4462-8fd1-71a1d6a9f163)

#### <span style="color: Cyan;">To get the namespace
```bash
kubectl get ns
```
```sh
ubuntu@ip-172-31-95-57:~$ kubectl get ns
NAME                   STATUS   AGE
argocd                 Active   4h34m
default                Active   4h39m
kube-node-lease        Active   4h39m
kube-public            Active   4h39m
kube-system            Active   4h39m
kubernetes-dashboard   Active   4h34m
prometheus             Active   4h34m
wanderlust             Active   22m
ubuntu@ip-172-31-95-57:~$
```

#### <span style="color: Cyan;">To get pods in prometheus
```bash
kubectl get pods -n prometheus
```
```sh
kubectl get pods -n prometheus
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-stable-kube-prometheus-sta-alertmanager-0   2/2     Running   0          4h35m
prometheus-stable-kube-prometheus-sta-prometheus-0       2/2     Running   0          4h35m
stable-grafana-86b6cdc46c-76wt5                          3/3     Running   0          4h35m
stable-kube-prometheus-sta-operator-58fc7ddb6b-clcqq     1/1     Running   0          4h35m
stable-kube-state-metrics-b65996c8d-fnvqs                1/1     Running   0          4h35m
stable-prometheus-node-exporter-pjrwr                    1/1     Running   0          4h35m
stable-prometheus-node-exporter-w44sw                    1/1     Running   0          4h35m
stable-prometheus-node-exporter-wpkkm                    1/1     Running   0          4h35m
```
#### <span style="color: Cyan;"> To get service in prometheus
```bash
kubectl get svc -n prometheus
```
![image-75](https://github.com/user-attachments/assets/138efa3e-c5f3-4502-a034-c17df6787d09)


#### <span style="color: Cyan;"> Expose Prometheus and Grafana to the external world through Node Port
> [!Important]
> change it from Cluster IP to NodePort after changing make sure you save the file and open the assigned nodeport to the service.

- For prometheus
```bash
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```
![image-76](https://github.com/user-attachments/assets/1a2c0673-2d10-42c4-a34a-5d8ddfb20af1)

- For Grafana
```bash
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```
![image-77](https://github.com/user-attachments/assets/a4238371-e9a3-4df0-b3ec-71496922e129)

#### <span style="color: Cyan;"> Verify Prometheus and Grafana accessibility
```bash
<worker-public-ip>:31205  # Prometheus <br>
<worker-public-ip>:32242  # Grafana 
```
**Note**- (always check in ```kubectl get svc -n prometheus```, it is running on which port)


http://44.192.109.76:31205/graph
![image-78](https://github.com/user-attachments/assets/2712b6a8-f46b-46c3-abbf-19396b3b1d53)


http://44.192.109.76:32242/
![image-79](https://github.com/user-attachments/assets/7dde347c-acb5-4c6b-a691-190d933780b8)

**Note**--> to get login password for grafan, you need to run the following command
```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
[!Note]
Default user login name is ```admin```

![image-80](https://github.com/user-attachments/assets/a53a4add-5f78-4580-87b7-d7f0e9c30c23)

Dashboard:
![image-82](https://github.com/user-attachments/assets/59ca56c6-7c16-4f2c-b5cf-d4f3852c1ae2)
![image-81](https://github.com/user-attachments/assets/57b157cf-2bf0-452e-b59b-754527db350d)
![image-83](https://github.com/user-attachments/assets/f5b31774-4973-4fd6-886c-7d5c51d9718a)


### <span style="color: Yellow;">Email Notification for successfull deployment: 
![image-85](https://github.com/user-attachments/assets/f1ba3683-367d-4c67-878e-5ff2a927b4cb)

### <span style="color: Yellow;"> Resources used in AWS:

- EC2 instances
![image-96](https://github.com/user-attachments/assets/249a7607-25e3-48b6-89ed-6fd0ec45ef2e)

- EKS Cluster 
![image-92](https://github.com/user-attachments/assets/7474696b-66d1-4a4c-93c6-09c08355a733)

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 
   - __```EKS cluster```__ first 
   - then delete the __```virtual machine```__.

#### To delete ```AWS EKS cluster```
   -   Login into the Jenkins Master EC2 instance and change the directory to /k8s_setup_file, and run the following command to delete the cluste.
```bash
cd /k8s_setup_file
sudo terraform destroy --auto-approve
```
#### Now, time to delete the ```Virtual machine```.
Go to folder *<span style="color: cyan;">"13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Key Takeaways
- __Automated pipelines__: This project will help you understand how to build a fully automated CI/CD pipeline from code to deployment.
- __Security Integration__: The importance of embedding security tools like OWASP and Trivy in the DevOps pipeline ensures secure code delivery.
- __Real-world implementation__: You’ll gain hands-on experience using modern tools in a real-world cloud environment.
  
## <span style="color: Yellow;"> What to Avoid
- __Skipping security checks__: Security is a core part of DevSecOps. Ignoring dependency checks or filesystem scans can lead to vulnerabilities in production.
- __Improper resource management__: In AWS EKS, over-provisioning resources can lead to unnecessary costs. Make sure to properly configure autoscaling and resource limits.
- __Manual interventions__: Automating processes like testing, scanning, and deployments are key in DevSecOps. Manual steps can introduce errors or delays.
  
## <span style="color: Yellow;"> Key Benefits
- __Improved security__: Using DevSecOps practices ensures that security is considered from the beginning, not as an afterthought.
- __Faster delivery__: With CI/CD tools like Jenkins and ArgoCD, you can deliver software updates and features much faster.
- __Scalability__: AWS EKS allows you to easily scale your Kubernetes clusters based on demand, ensuring high availability.

## <span style="color: Yellow;"> Conclusion

By following these steps and best practices, you can efficiently set up a CI/CD pipeline that enhances your deployment processes and streamlines your workflow.

Following these steps, you can successfully deploy and manage a Kubernetes application using Jenkins. Automating this process with Jenkins pipelines ensures consistent and reliable deployments.
If you found this guide helpful, please like and subscribe to my blog for more content. Feel free to reach out if you have any questions or need further assistance!


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=XaSdKR2fOU4&t=21621s "DevOps Production CICD Pipelines")

- [DevOps-Tools-Installations Guide](https://github.com/DevMadhup/DevOps-Tools-Installations)

<!-- Prometheus and Grafana:

Access Grafana via http://<your-server-ip>:31000 and Prometheus via http://<your-server-ip>:30000.


ArgoCD:

After installation, you can port-forward to access the ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Then, navigate to http://localhost:8080 in your browser.


SSH Access:

If you require SSH access to your worker nodes, ensure that the ec2_ssh_key_name variable is defined and that the corresponding SSH key pair exists in AWS. -->
