### In this project, we will build a CI/CD pipeline to deploy applications to a Kubernetes cluster using Jenkins. This comprehensive tutorial covers deploying to Kubernetes with Jenkins, providing hands-on experience with DevOps practices and Terraform. The project is an excellent opportunity to practice DevOps skills, featuring a complete CI/CD setup, AWS integration, SonarQube for code quality analysis, Trivy for security scanning, and deploying applications to AWS EKS. This guide is perfect for anyone looking to enhance their DevOps expertise through practical, real-world projects.

[YT Link](https://www.youtube.com/watch?v=dMVrwaYojYs&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=5)

- __URL Repo__: https://github.com/mrbalraj007/a-swiggy-clone/tree/main

Create a IAM user and give full admin previliage.

Configure the AWS account.

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve

will install few plug-in
- Eclipse Temurin installer
- SonarQube Scanner
- Sonar Quality Gates
- Quality Gates
- NodeJS
- Docker 
- Docker Commons
- Docker Pipeline
- Docker API
- docker-build-step
- 
### We needs to configure tools
Dashboard > Manage Jenkins > Tools
![alt text](image.png)

![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)

# Configure SonarQube and Integrate SonarQube with Jenkins

Generate the token from SonarQube
![alt text](image-4.png)
squ_ee2dd504da67bda0413a9f3a042c8decf510bab3

Will add that SonarQUbe Token in Jenkins.
![alt text](image-5.png)
![alt text](image-7.png)


Will go to SonarQube and configure as below
![alt text](image-6.png)

- Configure the webhook.

http://172.31.16.10:8080/sonarqube-webhook/
![alt text](image-8.png)

# Create Jenkins Pipeline to Build and Push Docker Image to DockerHib.

Create a pipeline
-Name: swiggy-CICD
Type: pipeline
![alt text](image-9.png)
```sh
pipeline{
     agent any
     
     tools{
         jdk 'jdk17'
         nodejs 'node16'
     }
     environment {
         SCANNER_HOME=tool 'sonarqube-scanner'
     }
     
     stages {
         stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
         stage('Checkout from Git'){
             steps{
                 git branch: 'main', url: 'https://github.com/mrbalraj007/a-swiggy-clone'
             }
         }
        stage("Sonarqube Analysis "){
             steps{
                 withSonarQubeEnv('SonarQube-Server') {
                     sh ''' 
                     $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Swiggy-CICD \
                     -Dsonar.projectKey=Swiggy-CICD 
                     '''
                 }
             }
         }
        stage("Quality Gate"){
            steps {
                 script {
                     waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                 }
             } 
         }
        stage('Install Dependencies') {
             steps {
                 sh "npm install"
             }
         }
         stage('TRIVY FS SCAN') {
             steps {
                 sh "trivy fs . > trivyfs.txt"
             }
         }
         
    }
}
```

![alt text](image-10.png)
![alt text](image-11.png)

### Dockerhub login

Will create a token from dockerhub, because that token would be used in pipeline.

- will configure docker account in jenkins
    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)
![alt text](image-12.png)

will add docker details in pipeline.

![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)


# Create AWS EKS cluster and download the Config/Secret file for EKS Cluster.

```sh
#1--Install kubectl on Jenkins
 sudo apt update
 sudo apt install curl
 curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
 sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
 kubectl version --client

# 2--Install AWS Cli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version

# 3--Installing  eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
cd /tmp
sudo mv /tmp/eksctl /bin
eksctl version
```
#### will create a new role and attach it to Jenkins server (where will be installing the ekscluster)
![alt text](image-16.png)
![alt text](image-17.png)

```sh
# 4--Setup Kubernetes using eksctl
# Refer--https://github.com/aws-samples/eks-workshop/issues/734
eksctl create cluster --name mr-singh-cluster \
--region us-east-1 \
--node-type t2.small \
--nodes 3

# 5-- Verify Cluster with below command
$ kubectl get nodes
$ kubectl get svc
```

# Configure the Jenkins Pipeline to Deploy Application on AWS EKS
Will install the following plug-in
![alt text](image-18.png)

![alt text](image-19.png)

![alt text](image-20.png)

- Config file saved on ``` saved kubeconfig as "/home/ubuntu/.kube/config"```

Open that file and save as ```secret.txt``

![alt text](image-21.png)

will configure the kubernets credentails.
    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)

![alt text](image-22.png)

```sh
pipeline{
     agent any
     
     tools{
         jdk 'jdk17'
         nodejs 'node16'
     }
     environment {
         SCANNER_HOME=tool 'sonarqube-scanner'
     }
     
     stages {
         stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
         stage('Checkout from Git'){
             steps{
                 git branch: 'main', url: 'https://github.com/mrbalraj007/a-swiggy-clone'
             }
         }
        stage("Sonarqube Analysis "){
             steps{
                 withSonarQubeEnv('SonarQube-Server') {
                     sh ''' 
                     $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Swiggy-CICD \
                     -Dsonar.projectKey=Swiggy-CICD 
                     '''
                 }
             }
         }
        stage("Quality Gate"){
            steps {
                 script {
                     waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                 }
             } 
         }
        stage('Install Dependencies') {
             steps {
                 sh "npm install"
             }
         }
         stage('TRIVY FS SCAN') {
             steps {
                 sh "trivy fs . > trivyfs.txt"
             }
         }
        stage("Docker Build & Push"){
             steps{
                 script{
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){   
                        sh "docker build -t swiggy-clone ."
                        sh "docker tag swiggy-clone balrajsi/swiggy-clone:latest "
                        sh "docker push balrajsi/swiggy-clone:latest "
                     }
                 }
             }
         }
        stage("TRIVY"){
             steps{
                 sh "trivy image balrajsi/swiggy-clone:latest > trivyimage.txt" 
             }
         }
        
        stage('Deploy to Kubernets'){
             steps{
                 script{
                     dir('Kubernetes') {
                         withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubernetes', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                         sh 'kubectl delete --all pods'
                         sh 'kubectl apply -f deployment.yml'
                         sh 'kubectl apply -f service.yml'
                         }   
                     }
                 }
             }
         } 
    }
}
```
Current state of nodes, service.

![alt text](image-23.png)
configure the pipeline and add stage.

![alt text](image-25.png)

Try to access the service and swiggy application should be accessible.
```sh
a696b038dc78e437b96524ce5e171a5a-2052783156.us-east-1.elb.amazonaws.com
```

![alt text](image-24.png)

# Set the trigger and Verify CI/CD Pipeline

now, we will try to automate the whole pipeline.

under the general
![alt text](image-26.png)

create a webhook with github<>Jenkins
![alt text](image-27.png)

![alt text](image-28.png)

![alt text](image-29.png)

Try to change in codes
![alt text](image-30.png)

****************************
# Cleanup
1--Delete EKS Cluster
```sh
eksctl delete cluster mr-singh-cluster --region us-east-1     
OR    
eksctl delete cluster --region=us-east-1 --name=mr-singh-cluster
```
2--Delete EC2 Instance with below Terraform Command
```sh
terraform destroy
```