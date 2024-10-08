# <span style="color: Yellow;"> Building a Blue-Green Deployment Pipeline with Jenkins and Kubernetes </span>
In this blog, we will explore how to set up a Blue-Green deployment pipeline using Jenkins and Kubernetes. This approach helps to minimize downtime and reduce risk during application updates. Let's dive into the details!

## <span style="color: Yellow;"> Prerequisites </span>
Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from k8s_setup_file/main.tf (i.e ```balraj```*).
  - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo](https://github.com/mrbalraj007/Blue-Green-Deployment.git)

- [x] __Git and GitHub__: You'll need to know the basics of Git for version control and GitHub for managing your repository.
- [x] __Jenkins Installed__: You need a running Jenkins instance for continuous integration and deployment.
- [x] __Docker__: Familiarity with Docker is essential for building and managing container images.
- [x] __Kubernetes (AWS EKS)__: Set up a Kubernetes cluster where you will deploy your applications.
- [x] __SonarQube__: Installed for code quality checks.
- [x] __Maven__: Installed for building Java applications.
- [x] __Nexus Repository__: Set up for storing artifacts.

## <span style="color: Yellow;"> Key Benefits of Using Blue-Green Deployment </span>
- __Reduced Downtime__: Users experience minimal disruption during updates.
- __Easy Rollbacks__: In case of issues, you can quickly switch back to the previous version.
- __Improved Testing__: New versions can be tested in production-like environments before fully switching traffic.

## <span style="color: Yellow;"> Steps to Set Up the Pipeline </span>
- __Configure SonarQube__: Use the Sonar scanner to analyze code quality. This involves setting up project keys and binary locations for Java applications.
- __Quality Gate Check__: In Jenkins, create a stage for code quality checks using SonarQube. Set up webhooks in SonarQube for Jenkins integration.
- __Build Application__:
    - Create a build stage in Jenkins using Maven.
    - Use mvn package to build the application, and skip tests if necessary.
- __Publish Artifacts__: Deploy artifacts to Nexus using the mvn deploy command.
- __Docker Image Build__:
    - Create Docker images for both blue and green environments.
    - Set up parameters to choose the environment before starting the pipeline.
- __Docker Image Scanning__: Use a tool to scan the Docker images for vulnerabilities.
- __Push Docker Images__: Push the images to Docker Hub.
- __Deploy MySQL Database__: Use Kubernetes to deploy the MySQL database, which remains unchanged during the application updates.
- __Deploy Application__: Deploy the application in either the blue or green environment based on the selected parameter.

- __Switch Traffic__: Use Kubernetes commands to switch traffic between blue and green deployments based on the parameter selected.
- __Verify Deployment__: Check the status of deployments and ensure everything is running smoothly.

## <span style="color: Yellow;"> Key Points
- Blue-Green Deployment: A technique that reduces downtime and risk by running two identical environments, one active (blue) and one idle (green). Traffic is switched between the two environments.
- Jenkins: Used as the CI/CD tool to automate the deployment process.
- Docker: Facilitates the creation of container images for our application.
- Kubernetes: Manages the deployment of applications in containers and helps in switching traffic between blue and green environments.
- Quality Checks: Integration with SonarQube for continuous code quality analysis.
- Nexus Repository: Used to store built artifacts for easy access and deployment.

## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform code to set up the entire environment, including the installation of required applications, tools, and the EKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> EKS cluster creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: brown;">Fours EC2 machines will be created named as ```"Jenkins", "Nexus", "SonarQube", "Terraform".```
- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Trivy Install
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


- Got email for successful deployment

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


- now, we will check the how many cluster have in argocd.
```bash
argocd cluster list
```


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


### <span style="color: Cyan;"> Deploy application through argocd.

- Now, we will add the application first.


- Health of the application


### <span style="color: Cyan;"> Verify application.
- Now, time to acces the application 
```bash
<worker-public-ip>:31000
```


Congratulations! :-) You have deployed the application successfully.

### <span style="color: Yellow;"> Status in Sonarqube


### <span style="color: Yellow;"> Image status in DockerHub


### <span style="color: Yellow;"> Configure observability (Monitoring)

#### <span style="color: Cyan;">List all Kubernetes pods in all namespaces:</span>
```sh
kubectl get pods -A
```
- To get the existing namespace 
```sh
kubectl get namespace
```


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


#### <span style="color: Cyan;"> Expose Prometheus and Grafana to the external world through Node Port
> [!Important]
> change it from Cluster IP to NodePort after changing make sure you save the file and open the assigned nodeport to the service.

- For prometheus
```bash
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```

- For Grafana
```bash
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```


#### <span style="color: Cyan;"> Verify Prometheus and Grafana accessibility
```bash
<worker-public-ip>:31205  # Prometheus <br>
<worker-public-ip>:32242  # Grafana 
```
**Note**- (always check in ```kubectl get svc -n prometheus```, it is running on which port)


http://44.192.109.76:31205/graph


http://44.192.109.76:32242/


**Note**--> to get login password for grafan, you need to run the following command
```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
[!Note]
Default user login name is ```admin```



Dashboard:



### <span style="color: Yellow;">Email Notification for successfull deployment: 


### <span style="color: Yellow;"> Resources used in AWS:

- EC2 instances

- EKS Cluster 


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

## <span style="color: Yellow;"> Conclusion

Setting up a Blue-Green deployment pipeline with Jenkins and Kubernetes can significantly enhance your application deployment process. This approach not only reduces downtime but also provides a safety net for quick rollbacks.

References
For a deeper understanding and detailed steps on similar setups, feel free to check the following technical blogs:


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=tstBG7RC9as&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=134 " Blue-Green Deployment CICD Pipeline")

