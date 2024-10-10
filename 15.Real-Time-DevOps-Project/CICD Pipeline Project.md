# <span style="color: Yellow;"> Building a Blue-Green Deployment Pipeline with Jenkins and Kubernetes </span>
In this blog, we will explore how to set up a Blue-Green deployment pipeline using Jenkins and Kubernetes. This approach helps to minimize downtime and reduce risk during application updates. Let's dive into the details!

## <span style="color: Yellow;"> Prerequisites </span>
Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/15.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
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
- &rArr;<span style="color: brown;"> EKS Cluster Setup
- &rArr;<span style="color: brown;"> Nexus Install

### <span style="color: Yellow;"> EC2 Instances creation

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"15.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
da---l          07/10/24   4:43 PM                k8s_setup_file
da---l          07/10/24   4:01 PM                scripts
-a---l          29/09/24  10:44 AM            507 .gitignore
-a---l          09/10/24  10:57 AM           8351 main.tf
-a---l          16/07/21   4:53 PM           1696 MYLABKEY.pem
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

da---l          07/10/24   4:43 PM                k8s_setup_file
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
![image](https://github.com/user-attachments/assets/e611b2da-88fb-47c2-989f-ad58b6d42f90)


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

- From Terraform:
![image-1](https://github.com/user-attachments/assets/e3229a10-2c30-4694-ad3b-99ae0e35252d)
![image-2](https://github.com/user-attachments/assets/a1082c77-1607-4093-b8a7-41c94e358473)

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

On the ```Terraform``` virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
```sh
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ pwd
/home/ubuntu/k8s_setup_file
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ cd ..
```

After Terraform deploys on the instance, now it's time to setup the cluster. You can SSH into the instance and run:

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
![image-3](https://github.com/user-attachments/assets/4818cf2e-c970-4309-96e3-84d3a7ccd7a7)

<details><summary><b><span style="color: Orange;">Change the hostname: (optional)</b></summary><br>

sudo terraform show

```bash
sudo hostnamectl set-hostname jenkins-svr
sudo hostnamectl set-hostname terraform
sudo hostnamectl set-hostname sonarqube
sudo hostnamectl set-hostname nexus
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
</details>

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
Kubernetes
Kubernetes CLI
OWASP Dependency-Check
SonarQube Scanner
Config File Provider
Maven Integration
Pipeline Maven Integration
```

- Run any job and verify that job is executing successfully.
   - create a below pipeline and build it and verify the outcomes.
```bash
pipeline {
    agent any

    stages {
        stage('code') {
            steps {
                echo 'This is cloning the code'
                git branch: 'main', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
                echo "This is cloning the code"
            }
        }
    }
}
```

![image-9](https://github.com/user-attachments/assets/2ba675e9-7ccb-4fb2-b8e1-2d8fd3bb29a7)

### <span style="color: cyan;"> Configure SonarQube </span>

<public IP address: 9000>

![image-15](https://github.com/user-attachments/assets/ab812f25-e5ec-4346-a4b6-967883a343a2)
  default login : admin/admin <br>
  You have to change password as per below screenshot
![image-16](https://github.com/user-attachments/assets/f35e952a-249a-4788-b9d4-fbaa1348f5ca)


### <span style="color: cyan;"> Configure Nexus </span>
<public IP address: 8180>

  default login : admin <br>
  You have to change password as per below screenshot
![image-10](https://github.com/user-attachments/assets/336ff105-2225-4d51-a802-4e8e3bc7d280)

login into Nexus EC2 instance
```bash
ubuntu@ip-172-31-16-90:~$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                       NAMES
515e835cd107   sonatype/nexus3   "/opt/sonatype/nexus…"   13 minutes ago   Up 13 minutes   0.0.0.0:8081->8081/tcp, :::8081->8081/tcp   Nexus-Server
ubuntu@ip-172-31-16-90:~$
```
We need to login to the container to retrieve the admin password.
```sh
sudo docker exec -it <container ID> /bin/bash
```

```bash
ubuntu@ip-172-31-16-90:~$ sudo docker exec -it 515e835cd107 /bin/bash
bash-4.4$ ls
nexus  sonatype-work  start-nexus-repository-manager.sh
bash-4.4$ cd nexus/
bash-4.4$ ls
NOTICE.txt  OSS-LICENSE.txt  PRO-LICENSE.txt  bin  deploy  etc  lib  public  replicator  system
bash-4.4$ cd ..
bash-4.4$ ls
nexus  sonatype-work  start-nexus-repository-manager.sh
bash-4.4$ cd sonatype-work/
bash-4.4$ ls
nexus3
bash-4.4$ cd nexus3/
bash-4.4$ ls
admin.password  cache  elasticsearch  generated-bundles  javaprefs  keystores  log   restore-from-backup
blobs           db     etc            instances          karaf.pid  lock       port  tmp
bash-4.4$ cat admin.password
820af89c-cef2-472d-8ba8-3cf374bb1b20   # Default Password for Admin
bash-4.4$
```
![image-11](https://github.com/user-attachments/assets/f6212fdf-be82-4aa5-84f9-483401bf80d5)
![image-12](https://github.com/user-attachments/assets/41308ae1-e9da-4db4-833f-3494b88f7791)
![image-13](https://github.com/user-attachments/assets/523cfd02-d7cc-4760-880d-0eb2c6121cf8)
![image-14](https://github.com/user-attachments/assets/338ceb09-7bba-49be-8767-991b0bf89d4f)


### <span style="color: cyan;"> Configure the RBAC </span>
On to Terraform EC2
```sh
kubectl create ns webapps
```

- Create a file svc.yml
```sh
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: webapps
```
```sh
kubectl apply -f svc.yml
serviceaccount/jenkins created
```
- To create a role
    - Create a file role.yml
```sh
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
      - secrets
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
```sh
kubectl apply -f role.yml
role.rbac.authorization.k8s.io/app-role created
```
- Bind the role to service account
  - Create a file bind.yml
```sh
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
``
```sh
kubectl apply -f bind.yml
rolebinding.rbac.authorization.k8s.io/app-rolebinding created
```
- To service account
  - Create a file sec.yml
```sh
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  annotations:
    kubernetes.io/service-account.name: jenkins
```
```sh
kubectl apply -f sec.yml -n webapps
secret/mysecretname created
```

- To get the token.

```sh
 kubectl get secret -n webapps
NAME           TYPE                                  DATA   AGE
mysecretname   kubernetes.io/service-account-token   3      63s
ubuntu@ip-172-31-93-220:~$ kubectl describe secret mysecretname -n webapps
Name:         mysecretname
Namespace:    webapps
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: jenkins
              kubernetes.io/service-account.uid: afcdd665-2b33-4079-9905-736029df259b

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1107 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IjFBZE9BWDhYRGxFejlQVkdrSWJXRDBYdVdrWVRaSThxdU42eGdpdnEwTjAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ3ZWJhcHBzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im15c2VjcmV0bmFtZSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiYWZjZGQ2NjUtMmIzMy00MDc5LTk5MDUtNzM2MDI5ZGYyNTliIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OndlYmFwcHM6amVua2lucyJ9.gJvKqVY4fnLCeMKX8tNGt1LfM6yYkgrIEf0tmLH5Q8HOQJIfs0JLWMEIGLQkMJx-0qpFRoOgznHn9cYHh1o_tnbbkEQdi1VACGTMmjBXbK-cscPMGK-lTnw7-wV-Y-lmeTw3PMRczBX3IqAdsyzUVPlKaXRpDA1t48FV1SXvvkTArK0exy-524B8WJ7SADYwogHMj41PYfaY5uMIkQlfDYz45Kb93tfvnbxeO7YnZ2biIqMF4FNI24kw_WutDiE6tsURXyYJf5oOq6mrtzTolb0grRuWPgoFPxbD-eV_5I4cO_1QYlyqxlJt8cbQnK1f5SIHzDZyhp_JYRghG_cd4Q
```

- Configure/Add the token into Jenkins, which will be used in the pipeline.<br>
  - Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)

![image-16](https://github.com/user-attachments/assets/0978a3a8-5ebb-4086-aa00-75df0fb3a258)

<!-- 
- Create a ClusterRole for PV access
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: persistent-volume-access
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```

- Bind the clusterRole to Jenkins Service Account
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-persistent-volume-access
subjects:
  - kind: ServiceAccount
    name: jenkins
    namespace: webapps
roleRef:
  kind: ClusterRole
  name: persistent-volume-access
  apiGroup: rbac.authorization.k8s.io
``` -->

- build a pipeline.
```sh
```

## <span style="color: yellow;"> Configure the tools </span> 
- Maven
   - Dashboard> Manage Jenkins> Tools

![image-17](https://github.com/user-attachments/assets/cd0ad587-ed0d-4c44-a206-12b63e166247)
![image-18](https://github.com/user-attachments/assets/8b4822d3-047b-4874-a059-d41ed6c9b3a9)


### <span style="color: cyan;"> Configure Nexus </span>
![image-27](https://github.com/user-attachments/assets/16816600-46a4-4a4a-afdb-52f3cda7a1bb)
![image-28](https://github.com/user-attachments/assets/66d2fd3c-9e26-48f9-ac9b-2204243247d3)
![image-29](https://github.com/user-attachments/assets/ddfa753d-0449-49e4-8c46-d51f5012021c)

add credential to Nexus Server

- Remove the comment from line 125 and paste it to line number after 118 as below-
![image-30](https://github.com/user-attachments/assets/d775b2cf-c20b-479a-871f-63acc4d8d181)

- for Java based application, we have to add the following two credentials.
```bash
    <server>
      <id>maven-releases</id>
      <username>admin</username>
      <password>password</password>
    </server>
    
    <server>
      <id>maven-snapshots</id>
      <username>admin</username>
      <password>password</password>
    </server>
```
![image-33](https://github.com/user-attachments/assets/ca5c3c12-e029-4c7a-8b0f-de4a3ffcdd99)


How to get details, go to Nexus. <br> 
http://3.84.186.15:8081/repository/maven-releases/ <br>
http://3.84.186.15:8081/repository/maven-snapshots/

![image-31](https://github.com/user-attachments/assets/a602de33-55fe-40cf-aa44-c03adc691d04)
![image-32](https://github.com/user-attachments/assets/e75a3cc7-0f02-441d-94e6-be82ceffff3a)

Go to Application Repo and select the pom.xml
![image-34](https://github.com/user-attachments/assets/159d6b98-a021-41db-9aca-26154fd084c1)


***************************************

### <span style="color: cyan;"> Integrate SonarQube in Jenkins.</span>
Go to Sonarqube and generate the token

> Administration> Security> users>

![image-24](https://github.com/user-attachments/assets/30d99980-a369-4409-bb73-14b943fbfe14)
![image-25](https://github.com/user-attachments/assets/3b4d4339-2e5c-4fb4-916b-05259ff52100)
![image-26](https://github.com/user-attachments/assets/8d8e4a99-6de7-452f-af08-e32a70d129b3)


now, open Jenkins UI and create a credential for sonarqube
> Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
![image-24](https://github.com/user-attachments/assets/b3a0605c-38b0-4353-977d-669a6aa41f76)

#### <span style="color: cyan;"> Configure the ```sonarqube scanner``` in Jenkins.</span>
> Dashboard> Manage Jenkins> Tools

Search for ```SonarQube Scanner installations``` 
![image-28](https://github.com/user-attachments/assets/a6eb21a9-c5e9-4e3d-89c5-da58a5b5cfa2)
![image-20](https://github.com/user-attachments/assets/aed4baa6-f96e-4018-b16d-1ebd84aa47eb)


#### <span style="color: cyan;"> Configure the ```sonarqube server``` in Jenkins.</span>
On Jenkins UI:
  > Dashboard> Manage Jenkins> System > Search for ```SonarQube installations``` 
![image-25](https://github.com/user-attachments/assets/c1c489b3-6f9b-47c7-a3bf-89e8083ca787)

        Name: sonar
        server URL: <http:Sonarqube IP address:9000>
        Server authenticatoin Token: select the sonarqube token from list.
![image-26](https://github.com/user-attachments/assets/46cbae72-16c5-41ac-9d38-0a0d2b319e6b)


Now, we will configure the ```webhook``` for code quality check in Sonarqube
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


- Create a pipeline and build it
```sh
pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
     parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
     environment {
        IMAGE_NAME = "balrajsi/bankapp"
        TAG = "${params.DOCKER_TAG}"  // The image tag now comes from the parameter 
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('tests') {
            steps {
                sh 'mvn test -DskipTests=true' 
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('sonarqube analysis') {
            steps {
            withSonarQubeEnv('sonar') {
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql -Dsonar.projectName=nodejsmysql -Dsonar.java.binaries=target"
                }    
            }
        }
         stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'NANOSECONDS') {
                   waitForQualityGate abortPipeline: false 
              }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'meven-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                   sh 'mvn deploy -DskipTests=true'     
              }
            }
        }
   }   
}                       
```

Build failed 😢
![image-37](https://github.com/user-attachments/assets/a80fb77b-6c35-4b56-a783-79c9d34c1356)

![image-40](https://github.com/user-attachments/assets/226197f3-d85c-4b1a-8bde-94ef25e74b6f)

****
## <span style="color: yellow;"> Troubleshooting: </span>
I encountered an error where the SonarScanner failed to connect to the SonarQube server due to an incorrectly specified server URL. Specifically, the error indicates that no URL scheme (http or https) was found for the SonarQube server's address.
I have configured it as below; 
here, ```http``` was missing:

![image-38](https://github.com/user-attachments/assets/eaafabe1-09c5-4f80-afa0-bd182cd3bfa5)

This is how it should be configured:
![image-39](https://github.com/user-attachments/assets/cba6e230-ec5c-4b5a-96f1-6a94284d7315)

Now, I tried to build it again, but it keeps failing.
![image-41](https://github.com/user-attachments/assets/58887d45-820b-4036-8b32-b5d410da9e96)


**Note**: The pipeline was aborted, and I noticed that I was using "NANOSECONDS" in the pipeline; however, it should be "HOURS.".
****
Here is corrected pipeline.

```sh
pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
     parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
     environment {
        IMAGE_NAME = "balrajsi/bankapp"
        TAG = "${params.DOCKER_TAG}"  // The image tag now comes from the parameter 
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('tests') {
            steps {
                sh 'mvn test -DskipTests=true' 
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('sonarqube analysis') {
            steps {
            withSonarQubeEnv('sonar') {
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql -Dsonar.projectName=nodejsmysql -Dsonar.java.binaries=target"
                }    
            }
        }
         stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                   waitForQualityGate abortPipeline: false 
              }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'meven-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                   sh 'mvn deploy -DskipTests=true'     
              }
            }
        }
   }   
} 
```

- add parameter for``` blue and green``` environment and below is the updated pipeline.
```sh
pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
     parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
     environment {
        IMAGE_NAME = "balrajsi/bankapp"
        TAG = "${params.DOCKER_TAG}"  // The image tag now comes from the parameter 
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('tests') {
            steps {
                sh 'mvn test -DskipTests=true' 
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('sonarqube analysis') {
            steps {
            withSonarQubeEnv('sonar') {
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql -Dsonar.projectName=nodejsmysql -Dsonar.java.binaries=target"
                }    
            }
        }
         stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: false
              }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'meven-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                   sh 'mvn deploy -DskipTests=true'     
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
               script{
                  withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
                 }
               }
            }
        }
         stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o fs.html ${IMAGE_NAME}:${TAG}'
            }
        }
        stage('Docker push Image') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker push ${IMAGE_NAME}:${TAG}'
              }
            }
            }
        }
        
   }   
}        
```
Again build failed ;-)
![image-44](https://github.com/user-attachments/assets/2aabd326-8cbd-4598-98fa-544c70b157aa)


- **Troubleshooting and Solution**:
    - Add the User to the Docker Group (Run the following command to add the Jenkins user (replace jenkins if Jenkins is running under a different user) to the docker group:)<br>
            
            sudo usermod -aG docker jenkins
            
    - Restart Jenkins and Docker (After adding the Jenkins user to the docker group, restart Jenkins and Docker for the changes to take effect:)
           
            sudo systemctl restart jenkins
            sudo systemctl restart docker
           
    - Verify Membership (You can verify if the user has been added to the docker group by running:)
           
            groups jenkins
           
    - Verify Permissions for /var/run/docker.sock (Check the permissions on the Docker socket to ensure it is accessible by the docker group:)
           
            ls -l /var/run/docker.sock
           
            It should show something like:
               srw-rw---- 1 root docker 0 Oct  9 09:42 /var/run/docker.sock
            
            If the group is not docker, you may need to correct the ownership by running:
                sudo chown root:docker /var/run/docker.sock
            
            Ensure that group members have read and write permissions:
                sudo chmod 660 /var/run/docker.sock
            
    - **Test the docker login connectivity**: Once the above steps are complete, test the setup by running a simple Docker command in the Jenkins pipeline to verify that the issue is resolved:
        ```sh
        Copy code
        pipeline {
            agent any
            stages {
                stage('Test Docker') {
                    steps {
                        sh 'docker ps'
                    }
                }
            }
        }
        ```
![image-45](https://github.com/user-attachments/assets/b75856c3-2c98-4706-ba2b-7e23932afe28)


**Now, run the build again.**

![image-46](https://github.com/user-attachments/assets/8499853d-02d3-49b9-89f9-e24fa40510b1)

- **Image view from Docker Hub**:
![image-47](https://github.com/user-attachments/assets/06757c1d-fcb9-4e5d-a150-a3615ac5c936)

- **View from SonarQube:**
![image-48](https://github.com/user-attachments/assets/b8c82caf-78e0-44cc-a5fb-35a4dd3532fa)

- **View from Nexus:**
![image-49](https://github.com/user-attachments/assets/8d2936ab-40a6-4e51-ab7d-3619785de914)


- Add the **```MySQL Deployment, Service and SVC-APP```** in pipeline

here is the complete pipeline.

```sh
pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
     parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
     environment {
        IMAGE_NAME = "balrajsi/bankapp"
        TAG = "${params.DOCKER_TAG}"  // The image tag now comes from the parameter
        KUBE_NAMESPACE = 'webapps'
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('tests') {
            steps {
                sh 'mvn test -DskipTests=true' 
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('sonarqube analysis') {
            steps {
            withSonarQubeEnv('sonar') {
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql -Dsonar.projectName=nodejsmysql -Dsonar.java.binaries=target"
                }    
            }
        }
         stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: false
              }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'meven-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                   sh 'mvn deploy -DskipTests=true'     
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
               script{
                  withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
                 }
               }
            }
        }
         stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o fs.html ${IMAGE_NAME}:${TAG}'
            }
        }
        stage('Docker push Image') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker push ${IMAGE_NAME}:${TAG}'
              }
            }
            }
        }
        stage('Deploy MySQL Deployment and Service') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh "kubectl apply -f mysql-ds.yml -n ${KUBE_NAMESPACE}"  // Ensure you have the MySQL deployment YAML ready
                    }
                }
            }
        }
        
        stage('Deploy SVC-APP') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh """ if ! kubectl get svc bankapp-service -n ${KUBE_NAMESPACE}; then
                                kubectl apply -f bankapp-service.yml -n ${KUBE_NAMESPACE}
                              fi
                        """
                   }
                }
            }
        }
        
   }   
}        
```

![image-50](https://github.com/user-attachments/assets/1c078ea1-e192-4d01-aa50-9166fea37512)

From Terraform VM:

![image-51](https://github.com/user-attachments/assets/e8f7a64c-369f-40a5-971a-17654693ed67)
![image-52](https://github.com/user-attachments/assets/373fa8f0-24b7-424c-87a2-1a75b73241b8)

```sh
ubuntu@ip-172-31-93-220:~$ kubectl get pods -n webapps
NAME                   READY   STATUS    RESTARTS   AGE
mysql-f5c84b88-2jf6r   1/1     Running   0          24m
```
```sh
ubuntu@ip-172-31-93-220:~$ kubectl get svc -n webapps
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP                                                             PORT(S)        AGE
bankapp-service   LoadBalancer   172.20.249.93   aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com   80:32657/TCP   24m
mysql-service     ClusterIP      172.20.64.19    <none>                                                                  3306/TCP       24m
ubuntu@ip-172-31-93-220:~$
```
```sh
ubuntu@ip-172-31-93-220:~$ kubectl get nodes
NAME                         STATUS   ROLES    AGE     VERSION
ip-10-0-1-17.ec2.internal    Ready    <none>   4h15m   v1.30.4-eks-a737599
ip-10-0-2-201.ec2.internal   Ready    <none>   4h15m   v1.30.4-eks-a737599
ip-10-0-2-220.ec2.internal   Ready    <none>   4h15m   v1.30.4-eks-a737599
```

- **Deploy to K8s**

```sh
pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
     parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
     environment {
        IMAGE_NAME = "balrajsi/bankapp"
        TAG = "${params.DOCKER_TAG}"  // The image tag now comes from the parameter
        KUBE_NAMESPACE = 'webapps'
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/mrbalraj007/Blue-Green-Deployment.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        
        stage('tests') {
            steps {
                sh 'mvn test -DskipTests=true' 
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('sonarqube analysis') {
            steps {
            withSonarQubeEnv('sonar') {
                 sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql -Dsonar.projectName=nodejsmysql -Dsonar.java.binaries=target"
                }    
            }
        }
         stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: false
              }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'meven-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                   sh 'mvn deploy -DskipTests=true'     
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
               script{
                  withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
                 }
               }
            }
        }
         stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o fs.html ${IMAGE_NAME}:${TAG}'
            }
        }
        stage('Docker push Image') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker-cred') {
                      sh 'docker push ${IMAGE_NAME}:${TAG}'
              }
            }
            }
        }
        stage('Deploy MySQL Deployment and Service') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh "kubectl apply -f mysql-ds.yml -n ${KUBE_NAMESPACE}"  // Ensure you have the MySQL deployment YAML ready
                    }
                }
            }
        }
        
        stage('Deploy SVC-APP') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh """ if ! kubectl get svc bankapp-service -n ${KUBE_NAMESPACE}; then
                                kubectl apply -f bankapp-service.yml -n ${KUBE_NAMESPACE}
                              fi
                        """
                   }
                }
            }
        }
         stage('Deploy to Kubernetes') {
            steps {
                script {
                    def deploymentFile = ""
                    if (params.DEPLOY_ENV == 'blue') {
                        deploymentFile = 'app-deployment-blue.yml'
                    } else {
                        deploymentFile = 'app-deployment-green.yml'
                    }

                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh "kubectl apply -f ${deploymentFile} -n ${KUBE_NAMESPACE}"
                    }
                }
            }
        }
        
        stage('Switch Traffic Between Blue & Green Environment') {
            when {
                expression { return params.SWITCH_TRAFFIC }
            }
            steps {
                script {
                    def newEnv = params.DEPLOY_ENV

                    // Always switch traffic based on DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh '''
                            kubectl patch service bankapp-service -p "{\\"spec\\": {\\"selector\\": {\\"app\\": \\"bankapp\\", \\"version\\": \\"''' + newEnv + '''\\"}}}" -n ${KUBE_NAMESPACE}
                        '''
                    }
                    echo "Traffic has been switched to the ${newEnv} environment."
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    def verifyEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://46BCE22A20C7B7BD3991293F82452A40.gr7.us-east-1.eks.amazonaws.com') {
                        sh """
                        kubectl get pods -l version=${verifyEnv} -n ${KUBE_NAMESPACE}
                        kubectl get svc bankapp-service -n ${KUBE_NAMESPACE}
                        """
                    }
                }
            }
        }
   }   
}        
```
Build Status
![image-53](https://github.com/user-attachments/assets/d3fc75a1-0c38-4c07-a6b8-6de46b64d4bd)

### <span style="color: Cyan;"> Verify application.
- Now, time to acces the application 
```bash
aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com
```
Try to access application throught the URL (aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com) in browser.
```sh
ubuntu@ip-172-31-93-220:~$ kubectl get svc -n webapps
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP                                                             PORT(S)        AGE
bankapp-service   LoadBalancer   172.20.249.93   aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com   80:32657/TCP   33m
mysql-service     ClusterIP      172.20.64.19    <none>                                                                  3306/TCP       33m
```


![image-54](https://github.com/user-attachments/assets/85672827-0c28-4d1b-aec7-90694dd30cda)

Congratulations! :-) You have deployed the application successfully.


You have to run the pipeline for Green environment as well.
![image-55](https://github.com/user-attachments/assets/8b0b01b3-ca44-489f-8465-3b18c8166338)
![image-56](https://github.com/user-attachments/assets/90a55c20-f2a6-4d4a-aef5-e0d78b1b7ba1)


Now run the pipeline again to switch traffic.
![image-57](https://github.com/user-attachments/assets/ef72e499-b531-4a72-8ec6-b86ad16496b9)

```sh
ubuntu@ip-172-31-93-220:~$ kubectl get all -n webapps
NAME                                 READY   STATUS    RESTARTS   AGE
pod/bankapp-blue-bcc84fb84-9mbsk     1/1     Running   0          7m16s
pod/bankapp-green-57bd8b8b58-45nrb   1/1     Running   0          5m10s
pod/mysql-f5c84b88-2jf6r             1/1     Running   0          38m

NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP                                                             PORT(S)        AGE
service/bankapp-service   LoadBalancer   172.20.249.93   aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com   80:32657/TCP   38m
service/mysql-service     ClusterIP      172.20.64.19    <none>                                                                  3306/TCP       38m

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/bankapp-blue    1/1     1            1           7m16s
deployment.apps/bankapp-green   1/1     1            1           5m10s
deployment.apps/mysql           1/1     1            1           38m

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/bankapp-blue-bcc84fb84     1         1         1       7m16s
replicaset.apps/bankapp-green-57bd8b8b58   1         1         1       5m10s
replicaset.apps/mysql-f5c84b88             1         1         1       38m
ubuntu@ip-172-31-93-220:~$
```
- Pipeline Status:
![image-58](https://github.com/user-attachments/assets/6821c8b5-117e-4d18-8de2-b6c52706367f)
![image-59](https://github.com/user-attachments/assets/2e66e62f-6d5d-4aa4-901e-bfa9d84bc2ec)



I did the switch over to blue again and noticed their is no downtime
![image-60](https://github.com/user-attachments/assets/131210df-d34d-4866-810c-537cd05e5359)

```sh
Every 2.0s: kubectl get all -n webapps                                                                                                                              ip-172-31-93-220: Wed Oct  9 04:52:24 2024

NAME                                 READY   STATUS    RESTARTS   AGE
pod/bankapp-blue-bcc84fb84-9mbsk     1/1     Running   0          11m
pod/bankapp-green-57bd8b8b58-45nrb   1/1     Running   0          9m38s
pod/mysql-f5c84b88-2jf6r             1/1     Running   0          43m

NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP                                                             PORT(S)        AGE
service/bankapp-service   LoadBalancer   172.20.249.93   aba6848fca700468f834ff45be100a18-73608189.us-east-1.elb.amazonaws.com   80:32657/TCP   43m
service/mysql-service     ClusterIP      172.20.64.19    <none>                                                                  3306/TCP       43m

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/bankapp-blue    1/1     1            1           11m
deployment.apps/bankapp-green   1/1     1            1           9m38s
deployment.apps/mysql           1/1     1            1           43m

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/bankapp-blue-bcc84fb84     1         1         1       11m
replicaset.apps/bankapp-green-57bd8b8b58   1         1         1       9m38s
replicaset.apps/mysql-f5c84b88             1         1         1       43m

```
![image-61](https://github.com/user-attachments/assets/aee77798-07f0-4c24-ac0d-842109c350d8)


- **Nexus Status**
![image-62](https://github.com/user-attachments/assets/3b3ebd6f-21df-4300-a129-5d6a78c44410)

- **SonarQube Status**
![image-63](https://github.com/user-attachments/assets/913917ba-cea4-4f1b-82c3-db7166720674)
![image-64](https://github.com/user-attachments/assets/14089ab0-3870-464e-a813-b4aca7eaffb9)


### <span style="color: Yellow;"> Resources used in AWS:

- EC2 instances
![image-15](https://github.com/user-attachments/assets/5a9bd484-ee80-4500-a309-203ff89d09c1)



- EKS Cluster 
![image-65](https://github.com/user-attachments/assets/b325403d-40c5-46a8-aa5b-f96b8c626f20)


## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 
   - __```EKS cluster```__ first 
   - then delete the __```virtual machine```__.

#### To delete ```AWS EKS cluster```
   -   Login into the Terraform EC2 instance and change the directory to /k8s_setup_file, and run the following command to delete the cluste.
```bash
cd /k8s_setup_file
sudo terraform destroy --auto-approve
```
I was getting below error message while deleting the EKS cluster
![image-67](https://github.com/user-attachments/assets/7d3f41e5-a4c5-4bdd-91a8-b8f139629340)

### Solution: 
   - I. I have deleted the load balancer manually from the AWS console.
   
     ![image-66](https://github.com/user-attachments/assets/f7b3ea90-2260-46f0-b330-266d4654a02a)
   - II. Delete the VPC manually and try to rerun the Terraform command again and it works :-)

     ![image-68](https://github.com/user-attachments/assets/1822c909-ec48-414a-8068-28091a3687b4)

#### Now, time to delete the ```Virtual machine```.
Go to folder *<span style="color: cyan;">"15.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```
![image-69](https://github.com/user-attachments/assets/06fc10c7-ed2a-41a6-9b6d-5e29f33b8b8e)


## <span style="color: Yellow;"> Conclusion

Setting up a Blue-Green deployment pipeline with Jenkins and Kubernetes can significantly enhance your application deployment process. This approach not only reduces downtime but also provides a safety net for quick rollbacks.

References
For a deeper understanding and detailed steps on similar setups, feel free to check the following technical blogs:


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=tstBG7RC9as&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=134 " Blue-Green Deployment CICD Pipeline")
