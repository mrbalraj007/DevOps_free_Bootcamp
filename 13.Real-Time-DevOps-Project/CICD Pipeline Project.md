# <span style="color: Yellow;"> Building a Three-Tier Blogging App with DevSecOps: The WanderLust Mega Project" </span>
"WanderLust is a travel blog web application developed using the ```MERN stack (MongoDB, Express.js, React, and Node.js)```. This project is designed to foster open-source contributions, enhance React development skills, and provide hands-on experience with Git."

## <span style="color: Yellow;"> Prerequisites </span>
Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/13.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from k8s_setup_file/main.tf (i.e ```balraj```*).
  - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo](https://github.com/mrbalraj007/Wanderlust-Mega-Project.git)

https://github.com/mrbalraj007/django-notes-app.git

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

- &rArr; <span style="color: brown;">Two EC2 machine will be created named as "Jenkins Server & Agent"
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




### <span style="color: cyan;"> Install the plugin in Jenkins </span>

```sh
Docker
Docker Pipeline
Kubernetes
Kubernetes CLI
Multibranch Scan Webhook Trigger
Pipeline: Stage View
```

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

- To clean up, delete the ```AWS EKS cluster```
   -   Login into the EC2 instance and change the directory to /k8s_setup_file, and run the following command to delete the cluste.
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




Prometheus and Grafana:

Access Grafana via http://<your-server-ip>:31000 and Prometheus via http://<your-server-ip>:30000.


ArgoCD:

After installation, you can port-forward to access the ArgoCD UI:

bash
Copy code
kubectl port-forward svc/argocd-server -n argocd 8080:443
Then, navigate to http://localhost:8080 in your browser.


SSH Access:

If you require SSH access to your worker nodes, ensure that the ec2_ssh_key_name variable is defined and that the corresponding SSH key pair exists in AWS.