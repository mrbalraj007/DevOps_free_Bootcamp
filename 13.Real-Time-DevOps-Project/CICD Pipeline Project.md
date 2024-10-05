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

![alt text](image-14.png)


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

Open ```Jenkins UI ```and configure the agent.
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
![alt text](image-13.png)

## <span style="color: yellow;">Jenkins Shared Library
- Shared libraries in Jenkins Pipelines are reusable pieces of code that can be organized into functions and classes.
- These libraries allow you to encapsulate common logic, making it easier to maintain and share across multiple pipelines and projects.
- Shared library must be inside the **vars** directory in your github repository
- Shared library uses **groovy** syntax and file name ends with **.groovy** extension. 


### <span style="color: cyan;">How to create and use shared library in Jenkins.

### How to create Shared library
- Login to your Jenkins dashboard. <a href="">Jenkins Installation</a>
- Go to **Manage Jenkins** --> **System** and search for **Global Trusted Pipeline Libraries**.
<img src="https://github.com/DevMadhup/Jenkins_SharedLib/blob/main/assests/Sharedlib-config-1.png" />

  **Name:** Shared <br>
  **Default version:** \<branch name><br>
  **Project repository:** https://github.com/mrbalraj007/Jenkins_SharedLib.git <br>
****
![alt text](image-48.png)

https://github.com/mrbalraj007/Jenkins_SharedLib.git
![alt text](image-49.png)
![alt text](image-50.png)


<img src="https://github.com/DevMadhup/Jenkins_SharedLib/blob/main/assests/Sharedlib-config-2.png" />

### How to use it in Jenkins pipeline
- Go to your declarative pipeline
- Add **@Library('Shared') _** at the very first line of your jenkins pipeline.
<img src="https://github.com/DevMadhup/Jenkins_SharedLib/blob/main/assests/shared-lib-in-pipeline.png" />

**Note:** @Library() _ is the syntax to use shared library.



### <span style="color: cyan;"> Configure SonarQube </span>

<public IP address: 9000>

![alt text](image-15.png)
default login : admin/admin
change password
![alt text](image-16.png)

### <span style="color: cyan;"> Configure email:</span>

Open a Jenkins UI and go to 
    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)

![alt text](image-17.png)

##### <span style="color: cyan;">Configure email notification </span>
    Dashboard
    Manage Jenkins
    System

Search for "Extended E-mail Notification"

![alt text](image-18.png)
![alt text](image-19.png)
![alt text](image-20.png)

Open Gmail ID and have look for notification email:
![alt text](image-21.png)

### <span style="color: cyan;"> Configure OWASP:</span>
Dashboard
Manage Jenkins
Tools

search for ```Dependency-Check installations ```
![alt text](image-22.png)

![alt text](image-23.png)

### <span style="color: cyan;"> Integrate SonarQube in Jenkins.</span>
Go to Sonarqube and generate the token
![alt text](image-24.png)
![alt text](image-25.png)

squ_14bc93fbd3ddfa87367e1c19d54ff560f9dacffb

![alt text](image-26.png)

now, open Jenkins UI and create a credential for sonarqube
Dashboard
Manage Jenkins
Credentials
System
Global credentials (unrestricted)

![alt text](image-27.png)

#### <span style="color: cyan;"> Configure the sonarqube scanner in Jenkins.</span>

Dashboard
Manage Jenkins
Tools

Search for ```SonarQube Scanner installations``` 

![alt text](image-28.png)

![alt text](image-29.png)

#### <span style="color: cyan;"> Configure the Github in Jenkins.</span>
First generate the token first in github and configure it in Jenkins
Generate a token in Github

Now, open Jenkins UI
    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)

![alt text](image-30.png)


#### <span style="color: cyan;"> Configure the sonarqube server in Jenkins.</span>
On Jenkins UI:
    Dashboard
    Manage Jenkins
    System

Search for ```SonarQube installations``` 
![alt text](image-31.png)
![alt text](image-32.png)


Now, we will confire the ```webhook``` in Sonarqube
Open SonarQube UI:

![alt text](image-33.png)
![alt text](image-34.png)


### <span style="color: cyan;"> Configure the ArgoCD.</span>
- Get a argocd namespace
```bash
kubectl get namespace
```
![alt text](image-35.png)

- Get the argocd pods
```bash
kubectl get pods -n argocd
```
![alt text](image-36.png)

- Check argocd services
```bash
kubectl get svc -n argocd
```
![alt text](image-37.png)

**Change argocd server's service from ClusterIP to NodePort**
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n argocd
```
![alt text](image-38.png)

Now, try to access ArgoCd in browser.
<public-ip-worker>:<port>
![alt text](image-41.png)

**Note**: I was not able to access argocd in browser and noticed that port was not allowed.
You need to select any of the EKS cluster node and go to security group
Select the SG "sg-0838bf9c407b4b3e4" (You need to select yours one) and allow the all port range.
![alt text](image-39.png)

Now, try to access ArgoCd in browser.
![alt text](image-40.png)
```bash
https://44.192.109.76:31230/
```
Default login would be admin/admin
- To get the initial password of argocd server
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![alt text](image-42.png)

![alt text](image-43.png)

Update the password for argocd
![alt text](image-44.png)


### <span style="color: cyan;"> Configure the repositories in Argocd </span>
![alt text](image-45.png)

[Application Repo](https://github.com/mrbalraj007/Wanderlust-Mega-Project.git)

![alt text](image-46.png)

![alt text](image-47.png)


Update this jenkins file as per your requirement.
https://github.com/mrbalraj007/Wanderlust-Mega-Project/blob/main/Jenkinsfile



### <span style="color: cyan;"> Generate the docker Token and update in Jenkins.</span>
    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)

![alt text](image-51.png)


## <span style="color: Red;"> Troubleshooting while run CI Pipeline </span>

I was getting an error while running the CI job first time because due to missing required environment variables: ```FRONTEND_DOCKER_TAG``` and ```BACKEND_DOCKER_TAG```. 

Steps to Fix
Ensure Required Parameters Are Provided:

[!Important]
First time, when you run the pipeline, then the pipeline will fail because the parameter is not given. Try a second time and pass the parameter.

![alt text](image-52.png)

![alt text](image-54.png)

[!Note]
When I ran it again and got the below error message saying that Trivy was not found, I noticed that Trivy didn't install on the Jenkins agent machine. So, I have updated the Terraform script, and the pipeline should work.

![alt text](image-55.png)

Now, I got below error message "permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?". I have updated the Terraform script.

![alt text](image-56.png)

Solution:  
```bash
sudo usermod -aG docker $USER && newgrp docker
```
![alt text](image-57.png)

But I was still getting same error message to fix the issue.
![alt text](image-57.png)

Solution:  
```bash
sudo systemctl restart jenkins
```

![alt text](image-61.png)
![alt text](image-60.png)

![alt text](image-59.png)

For CD Job

```Gitops``` folder

copy the Jenkins pipeline from git repo and build a pipeline named as ```Wanderlust-CD```.

Now, run the ```Wanderlust-CI``` pipeline

![alt text](image-63.png)

Got email for successful deployment
![alt text](image-62.png)

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
![alt text](image-64.png)

- now, we will check the how many cluster have in argocd.
```bash
argocd cluster list
```
![alt text](image-65.png)

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
it will ask you to type type Yes/No...type `y`

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

![alt text](image-66.png)

![alt text](image-67.png)

### <span style="color: Cyan;"> Deploy application through argocd.

- Now, we will add the application.

![alt text](image-68.png)
![alt text](image-69.png)
![alt text](image-70.png)

- Health of the application
![alt text](image-71.png)
![alt text](image-72.png)


### <span style="color: Cyan;"> Verify application.
- Now, time to acces the application 
```bash
<worker-public-ip>:31000
```
![alt text](image-73.png)
![alt text](image-74.png)

Congratulations! :-) You have deployed the application successfully.


### <span style="color: Yellow;"> Configure observability (Monitoring)

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
![alt text](image-75.png)


#### <span style="color: Cyan;"> Expose Prometheus and Grafana to the external world through Node Port
> [!Important]
> change it from Cluster IP to NodePort after changing make sure you save the file and open the assigned nodeport to the service.

- For prometheus
```bash
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```
![alt text](image-76.png)

- For Grafana
```bash
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc -n prometheus
```
![alt text](image-77.png)

#### <span style="color: Cyan;"> Verify Prometheus and Grafana accessibility
```bash
<worker-public-ip>:31205  # Prometheus <br>
<worker-public-ip>:32242  # Grafana 
```
**Note**- (always check in ```kubectl get svc -n prometheus```, it is running on which port)


http://44.192.109.76:31205/graph
![alt text](image-78.png)


http://44.192.109.76:32242/
![alt text](image-79.png)

**Note**--> to get login password for grafan, you need to run the following command
```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
[!Note]
Default user login name is ```admin```

![alt text](image-80.png)

Dashboard:
![alt text](image-82.png)
![alt text](image-81.png)
![alt text](image-83.png)


Email Notification: 
![alt text](image-85.png)

![alt text](image-86.png)

![alt text](image-87.png)
![alt text](image-88.png)
![alt text](image-89.png)
![alt text](image-90.png)
![alt text](image-91.png)
![alt text](image-92.png)
![alt text](image-93.png)

![alt text](image-94.png)
![alt text](image-95.png)


![alt text](image-96.png)




![alt text](image-84.png)

























### <span style="color: cyan;"> Configure tools in Jenkins </span>
- Configure the docker
> Name- docker

> [x] install automatically
>
> docker version: latest
  
### <span style="color: cyan;"> Set docker cred in Jenkins </span>
-    Dashboard>Manage Jenkins > Credentials> System>
    Global credentials (unrestricted) &rArr; Click on "New credentials"
> kind: "username with password"

> username: your docker login ID
> 
> password: docker token
> 
> Id: docker-cred #it would be used in pipeline
> 
> Description:docker-cred



### <span style="color: cyan;"> Creating a multipipeline in Jenkins:</span>

> name: microservice-ecommerce
> 
> item type: Multibranch pipeline
> 

Syntax to configure the __webhooks__ in ```github``` 
```JENKINS_URL/multibranch-webhook-trigger/invoke?token=[Trigger token]```
```bash
http://18.234.174.99:8080/multibranch-webhook-trigger/invoke?token=singh
```
go to github repo > setting> webhooks

Once you configure __webhook__ then build the pipeline and you will see successfull build.

- Images view from ```Docker Hub```

## <span style="color: yellow;">Managing Docker and Kubernetes Pods

### <span style="color: Cyan;">Check Docker containers running:</span>
```sh
docker ps
```
```bash
ubuntu@ip-172-31-81-94:~$ docker ps
```


##### <span style="color: Cyan;">List all Kubernetes pods in all namespaces:</span>
```sh
kubectl get pods -A
```
- To get the existing namespace 
```sh
kubectl get namespace
```
```bash
ubuntu@ip-172-31-81-94:~$ kubectl get namespace
NAME                   STATUS   AGE
argocd                 Active   7m11s
default                Active   7m24s
kube-node-lease        Active   7m24s
kube-public            Active   7m24s
kube-system            Active   7m24s
kubernetes-dashboard   Active   7m1s
local-path-storage     Active   7m20s
monitoring             Active   6m54s
```

## <span style="color: yellow;"> Setup the EKS Cluster </span>


### <span style="color: cyan;"> Create Namespace:</span>
```bash
kubectl create namespace webapps
```

### <span style="color: cyan;"> Create Service Account:</span>
```bash
# vi svc.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: webapps
```
*__Steps__*:
> create a vi svc.yml and paste the above svc.yml content
>> run the following command

>> kubectl apply -f svc.yml


### <span style="color: cyan;"> Create Role and Role Binding:</span>
> Creating a Kubernetes Role</span>

To start, you'll need to define a role in Kubernetes that specifies the permissions for the resources you'll manage. Here's how to do it:

Create a YAML File: Define the role with necessary permissions (e.g., ```get, list, watch, create, update, patch, delete```).

We start by defining a Kubernetes Role with specific permissions using a YAML file.

- Create a role.yaml file to specify what resources the role can access and what actions it can perform (e.g., ```list, create, delete```).
-  Apply this configuration with ```kubectl apply -f role.yaml```.

```bash
# vi role.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: webapps
rules:
  - apiGroups:
        - ""
        - apps
        - autoscaling
        - batch
        - extensions
        - policy
        - rbac.authorization.k8s.io
    resources:
      - pods
      - componentstatuses
      - configmaps
      - daemonsets
      - deployments
      - events
      - endpoints
      - horizontalpodautoscalers
      - ingress
      - jobs
      - limitranges
      - namespaces
      - nodes
      - pods
      - persistentvolumes
      - persistentvolumeclaims
      - resourcequotas
      - replicasets
      - replicationcontrollers
      - serviceaccounts
      - services
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```
```bash
kubectl apply -f role.yaml
```

### <span style="color: cyan;"> Assigning the Role to a Service Account:

- We need to bind the created role to a service account using RoleBinding.
- Create a ```bind.yaml``` file to link the role with the service account.
- Apply this configuration with ```kubectl apply -f bind.yaml```.

```bash
vi bind.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
  namespace: webapps 
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-role 
subjects:
- namespace: webapps 
  kind: ServiceAccount
  name: jenkins 
```



### <span style="color: cyan;"> [Creating a Token for Authentication](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/#:~:text=To%20create%20a%20non%2Dexpiring,with%20that%20generated%20token%20data.): 

- Generate a token for the service account to authenticate with Kubernetes.
- Use a YAML file to create a Kubernetes Secret that stores the token.
  
- Apply this configuration with ```kubectl apply -f secret.yaml```.
```bash
# vi secret.yml
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  annotations:
    kubernetes.io/service-account.name: jenkins
```
- while applying, makesure, we will use namespace as below
```bash
kubectl apply -f secret.yml -n webapps
```

- Retrieve the token using ```kubectl describe secret <secret-name> -n webapps```.

```sh
ubuntu@ip-172-31-90-126:~$ kubectl get namespace
NAME              STATUS   AGE
default           Active   51m
kube-node-lease   Active   51m
kube-public       Active   51m
kube-system       Active   51m
webapps           Active   22m

ubuntu@ip-172-31-90-126:~$ kubectl get namespace webapps
NAME      STATUS   AGE
webapps   Active   22m
ubuntu@ip-172-31-90-126:~$

ubuntu@ip-172-31-90-126:~$ kubectl get secret -n webapps
NAME           TYPE                                  DATA   AGE
mysecretname   kubernetes.io/service-account-token   3      3m33s
```
```bash
kubectl describe secret mysecretname -n webapps
```


will save token somewhere, because we will be using the same token in CI/CD pipeline.
```bash
kubectl describe secret mysecretname -n webapps | grep token

Type:  kubernetes.io/service-account-token
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6InhpWmNCYi1ZaEFNaFJ0eWpmQVFvSFR0ZFlQbGJZSjNndXpEM3hCUDJhVkUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ3ZWJhcHBzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im15c2VjcmV0bmFtZSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiZWJjZmM4OTUtOTk4My00ZTIxLThmMTMtN2VhZTgzZmJmZWFjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OndlYmFwcHM6amVua2lucyJ9.Q4a0Er2viPrfPKZ7vW93FuC_P4S2uYXHkY9v37qvR69DLPXYgEJx9aXa2z2-WlKUt12WdRW-Gv53hAvF2hZjt8REwgqbe98Dohv1PmDLwxlycqj_WjCxTSFxobZqeDqHXo3VF6SawSTNPETx4WnXDqMjqyOKk0LHI-Sxi6CIOMVi4mlZUXWCEiyywE75RlK-E25yqTU9FB4M3hZ_v2cMNedyDOz2IITdLosr17L9HyvPo6-kmOk1qmrSryXwD9pX4cw4cRgiNZR3p5wy_9TF2WOxDsnKzuyjOOCBP1AKbdp673eJI20mGQS2EB8HFx13ql8f_pZn5-Bl82o0s83fBA
```

## <span style="color: Cyan;"> Setting Up Jenkins CD Pipeline:

- Create a Jenkins pipeline to handle the deployment process.
- Define the pipeline stages: deploy to Kubernetes and verify deployment.
- Configure Jenkins to use the service account token for Kubernetes API interactions.
- Use the pipeline syntax to apply Kubernetes configurations and monitor the deployment.
  
### <span style="color: Yellow;"> Configure the K8s token in Jenkins

Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
> kind: "Secret Text"

> Secret: Paste your token which you get from secert

> Id: k8-token #it would be used in pipeline
> 
> Description:k8-token



Finally, set up a Jenkins pipeline to automate deployment:

Create a ```dummy Jenkins Pipeline```: Define stages for deployment and verification.



add the following in pipeline
```bash
pipeline {
    agent any

    stages {
        stage('Deploy to Kubernets') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', serverUrl: 'https://7A88D591B76582F68E890F414CBE194C.gr7.us-east-1.eks.amazonaws.com']]) {
                     sh "kubectl apply -f deployment-service.yml"
                     sleep 60
               }
            }
        }    
  
        stage('Verify Deployment') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', serverUrl: 'https://7A88D591B76582F68E890F414CBE194C.gr7.us-east-1.eks.amazonaws.com']]) {
                     sh "kubectl get svc -n webapps"
                }
            }
        }
      }
    }
```
Same pipeline will add into the git repo in ```main branch```


Commit and Run: Commit the Jenkinsfile and let Jenkins pick it up. Monitor the deployment process and check the application URL once it’s up and running.



## <span style="color: Yellow;"> Deployment Verification

- Once the pipeline is set up, Jenkins will deploy the microservices and provide a URL to access the application.



- will browser the LB URL and website should be accessible.


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
