# <span style="color: Yellow;"> Deploying a Kubernetes Application with Jenkins: A Comprehensive Guide </span>


In this blog, we’ll walk through the process of deploying a Kubernetes application using Jenkins, along with integrating various tools like ```GitHub, Trivy, SonarQube, Nexus, Grafana, Docker, and Prometheus```. We will cover the setup, deployment, and monitoring stages to ensure a seamless and efficient pipeline.

## <span style="color: Yellow;">Key Technologies Used </span>
+ ```Jenkins```: An open-source automation server for building, deploying, and automating tasks.

+ ```GitHub```: A platform for version control and collaboration.

+ ```Trivy```: A vulnerability scanner for container images.
+ ```SonarQube```: A tool for continuous inspection of code quality.
+ ```Nexus```: A repository manager for managing dependencies and build artifacts.
+ ```Docker```: A platform for developing, shipping, and running applications in containers.
+ ```Docker Hub```: A cloud-based registry for Docker images.
+ ```Grafana```: A tool for monitoring and visualizing metrics.
+ ```Prometheus```: A monitoring system and time-series database.

### <span style="color: Yellow;">Setting Up the Environment </span>

1. Setting Up the Virtual Machines (EC2)

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a sample terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"08.Real-Time-DevOps-Project/Terraform_Code"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          25/08/24   8:43 PM                01.Code_IAC_Jenkins_Trivy
da---l          25/08/24   8:41 PM                02.Code_IAC_Nexus
da---l          25/08/24   8:39 PM                03.Code_IAC_SonarQube
da---l          26/08/24   9:48 AM                04.Code_IAC_Terraform_box
da---l          25/08/24   8:38 PM                05.Code_IAC_Grafana
-a---l          20/08/24   1:45 PM            493 .gitignore
-a---l          20/08/24   4:54 PM           1589 main.tf
```

You need to run ```main.tf``` file using following terraform command.

__<span style="color: Red;">Note__</span> &rArr; make sure you will run ```main.tf``` not from inside the folders.

```bash
cd 08.Real-Time-DevOps-Project/Terraform_Code

da---l          25/08/24   8:43 PM                01.Code_IAC_Jenkins_Trivy
da---l          25/08/24   8:41 PM                02.Code_IAC_Nexus
da---l          25/08/24   8:39 PM                03.Code_IAC_SonarQube
da---l          26/08/24   9:48 AM                04.Code_IAC_Terraform_box
da---l          25/08/24   8:38 PM                05.Code_IAC_Grafana
-a---l          20/08/24   1:45 PM            493 .gitignore
-a---l          20/08/24   4:54 PM           1589 main.tf

# Now, run the following command.
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```
-------
### __Environment Setup__
|HostName|
|----|
|Jenkins|
|SonarQube|
|Nexus|
|Terraform|
|Grafana|

> * Password for the **root** account on all these virtual machines is **xxxxxxx**
> * Perform all the commands as root user unless otherwise specified

- Change the hostname:
```bash
sudo hostnamectl set-hostname Jenkins
sudo hostnamectl set-hostname SonarQube
sudo hostnamectl set-hostname Nexus
sudo hostnamectl set-hostname Terraform
sudo hostnamectl set-hostname Grafana
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
## <span style="color: red;"> Setup for SonarQube</span>
```bash
http://publicIPofSonarQube:9000
```
```bash
http://54.87.30.87:9000/
```
![alt text](image.png)

### Default password is admin and you have to change it.
username: admin
password: admin

+ Create a token in sonarQube
![alt text](image-5.png)


## <span style="color: red;"> Setup for Nexus</span>
```bash
http://publicIPofNexux:8081
```
http://44.202.10.126:8081/

![alt text](image-1.png)

Now, we have to click on ```sign in```
![alt text](image-2.png)

We need a password, and we are using Docker. We have to go inside the container in order to get the password, which can be gotten from the container under the directory ```/nexus-data/admin.password```
```bash
sudo docker exec -it <containerID> /bin/bash
cat sonatype-work/nexus3/admin.password
```

```bash
ubuntu@ip-172-31-80-62:~$ docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                       NAMES
e56b0a042dda   sonatype/nexus3   "/opt/sonatype/nexus…"   25 minutes ago   Up 25 minutes   0.0.0.0:8081->8081/tcp, :::8081->8081/tcp   nexus3

ubuntu@ip-172-31-80-62:~$ sudo docker exec -it e56b0a042dda /bin/bash
bash-4.4$ ls
nexus  sonatype-work  start-nexus-repository-manager.sh
bash-4.4$ cd sonatype-work/
bash-4.4$ ls
nexus3
bash-4.4$ cd nexus3/
bash-4.4$ ls
admin.password  blobs  cache  db  elasticsearch  etc  generated-bundles  instances  javaprefs  karaf.pid  keystores  lock  log  port  restore-from-backup  tmp
bash-4.4$ cat admin.password
4fc19f70-71f5-4e26-901f-198a51e044ba
bash-4.4$
```
Type the new password
![alt text](image-3.png)

Select the ```enable anonymous access```

![alt text](image-4.png)
Finish the setup for Nexus.

## <span style="color: red;"> Set up Jenkins</span>

Once Jenkins is setup then install the following plug-in- 

- SonarQube Scanner
- Config File Provider
- Maven Integration
- Pipeline: Stage View 
- Pipeline Maven Integration
- Kubernetes Client API
- Kubernetes Credentials
- Kubernetes
- Kubernetes CLI 
- Docker
- Docker Pipeline
- Eclipse Temurin installer


### <span style="color: yellow;"> Configure the above plug-in </span>

Dashboard > Manage Jenkins> Tools

+ Configure ```Docker```<br>
Name: docker<br>
install automatically<br>
docker version: latest<br>
![alt text](image-6.png)


+ Configure ```Maven```<br>
Name: maven3<br>
install automatically<br>
![alt text](image-7.png)

+ Configure ```SonarQube Scanner installations```<br>
install automatically<br>
![alt text](image-8.png)

+ ```Configure JDK```<br>
install automatically<br>
version: jdk- 17.0.12+7<br>
![alt text](image-9.png)

+ Configure the ```SonarQube Server```<br>
we will configure the credential first.<br>
  Dashboard> Manage Jenkins> Credentials> System > Global credentials(unrestricted)<br>
![alt text](image-11.png)

Now, we will configure the server<br>
![alt text](image-12.png)

![alt text](image-13.png)

Configure the Nexus file<br>
![alt text](image-14.png)

++ Create a pipeling<br>
![alt text](image-10.png)
```sh
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mrbalraj007/FullStack-Blogging-App.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-App -Dsonar.projectKey=Blogging-App \
                      -Dsonar.java.binaries=target'''
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"  
              }
            }
        }
    }
}
```

Test the pipeline so far how it goes.
![alt text](image-15.png)

View from SonarQube:
![alt text](image-18.png)

View from Nexus:


> Now, we will create a private repogitory in Docker hub.
My repo name: balrajsi/bloggingapp
![alt text](image-16.png)

Apend the existing pipeline and below is the updated pipeline
```sh
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mrbalraj007/FullStack-Blogging-App.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-App -Dsonar.projectKey=Blogging-App \
                      -Dsonar.java.binaries=target'''
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"  
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker build -t balrajsi/bloggingapp:latest ."  
                }
              }
            }
        }
         stage('Trivy image Scan') {
            steps {
                sh "trivy image --format table -o image.html balrajsi/bloggingapp:latest"
            }
        }
         stage('Docker Push Image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker push balrajsi/bloggingapp:latest"  
                }
              }
            }
        }
    }
}
```

## <span style="color: red;">Now, we will setup an EKS cluster</span>
Once cluster is setup then we will use the following command to connect it from Terraform box.
```bash
aws eks --region <your region name> update-kubeconfig --name <your clustername>
```
```bash
aws eks --region us-east-1 update-kubeconfig --name balraj-cluster
```
<!-- ```yaml
Outputs:

cluster_id = "balraj-cluster"
node_group_id = "balraj-cluster:balraj-node-group"
subnet_ids = [
  "subnet-0cf91b87215290bf2",
  "subnet-0966b39083e33d00b",
]
vpc_id = "vpc-00e76ed9784ca75ff"
``` -->

+ Check the EKS cluster 
```sh
kubectl get nodes
```

```bash
ubuntu@ip-172-31-28-76:~/k8s_setup_file$ kubectl get nodes
NAME                         STATUS   ROLES    AGE   VERSION
ip-10-0-0-174.ec2.internal   Ready    <none>   13m   v1.30.2-eks-1552ad0
ip-10-0-0-39.ec2.internal    Ready    <none>   13m   v1.30.2-eks-1552ad0
ip-10-0-1-198.ec2.internal   Ready    <none>   13m   v1.30.2-eks-1552ad0
```
### <span style="color: yellow;">  Now, we have to do the RBAC configure for EKS cluster.

```css
comeout from directory "k8s_setup_file" 
cd ..
current path
/home/ubuntu   # Current path
```
### To create a namespace 
```bash
kubectl create ns webapps
```
### To create a service account

```bash
ubuntu@ip-172-31-28-76:~$ cat service.yml
apiVersion: v1
kind: ServiceAccount
metadata:
 name: jenkins
 namespace: webapps
```
command
```sh
kubectl apply -f service.yml
```

#### To test the yml file to see whether it's a valid configuration or not, we can use either ```dry-run``` or ```kubeval```

<details><summary>dry-run</b></summary></br> 
To dry run
kubectl apply --dry-run=client -f role.yaml
</details>
                             or 
                             
<details><summary>Kubebal</b></summary></br> 

[Kubeval](https://github.com/instrumenta/kubeval?tab=readme-ov-file) is a tool specifically designed for validating Kubernetes YAML files against the Kubernetes OpenAPI schemas.

Download the latest release:
```bash
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
```

Extract the archive:
```bash
tar xf kubeval-linux-amd64.tar.gz
```
Move the binary to a directory in your PATH:
```bash
sudo mv kubeval /usr/local/bin/
```
Verify the installation:
```bash
kubeval --version
```
</details>

*****************************
### To create a role
```css
ubuntu@ip-172-31-28-76:~$ cat roles.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: webapps
rules:
- apiGroups:
  - ""
  - apps
  - extensions
  - batch
  - autoscaling
  resources:
  - pods
  - secrets
  - services
  - deployments
  - replicasets
  - replicationcontrollers
  - componentstatuses
  - configmaps
  - daemonsets
  - events
  - endpoints
  - horizontalpodautoscalers
  - ingress
  - jobs
  - limitranges
  - namespaces
  - nodes
  - persistentvolumes
  - persistentvolumeclaims
  - resourcequotas
  - serviceaccounts
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```
### To bind the role to service account
```css
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
- kind: ServiceAccount
  name: jenkins
  namespace: webapps
```
### To create a token for service account
file name: jen-secret.yml
```sh
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: mysecretname
  annotations:
   kubernetes.io/service-account.name: jenkins
```

To apply to token you need to run with namespace as below
```sh
kubectl apply -f jen-secret.yml -n webapps
```

Now, you need to create a docker secret as we are using private repo in docker hub.
```bash
kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v1/ \
--docker-username=<username> \
--docker-password=<your_password> \
--namespace=webapps
```

```bash
 kubectl get secrets -n webapps
NAME           TYPE                                  DATA   AGE
mysecretname   kubernetes.io/service-account-token   3      8m1s
regcred        kubernetes.io/dockerconfigjson        1      60s
```

Now, we will get a secret password
```bash
kubectl describe secret mysecretname -n webapps
```
```bash
ubuntu@ip-172-31-28-76:~$ kubectl describe secret mysecretname -n webapps
Name:         mysecretname
Namespace:    webapps
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: jenkins
              kubernetes.io/service-account.uid: 234ebef6-6c09-414d-aa04-51ec4509a9cc

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1107 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImpRc1hZU01Meko5VXRUTE1HY2RpdFA4eTNjeUdQQkVOdXBsYmx3ZDZPLWMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ3ZWJhcHBzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im15c2VjcmV0bmFtZSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMjM0ZWJlZjYtNmMwOS00MTRkLWFhMDQtNTFlYzQ1MDlhOWNjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OndlYmFwcHM6amVua2lucyJ9.RFpA3VrD1hw2V8qGmMtLaRwMdlSxWxTYG2t8_NLueOKQIiIivpiRTLqEEcqgUNeCA5sKfK0qg0TeXz4h_b_8GkgtH-tGFVDzfXZ9XtkbFNgUp5HCdnMh_XKrY3HRhDwnBpzDPW0QkDofmmwXzJBUgv0FgD_MO-3kxUBp8fbEa5Tjtl6LXCzLtviLDyTSfubWgsoYff7GUOHAkb1lWw7yhAV-dvSj54iqmb2WqqGMFtkZeDi9Gz8q2IVN9I8txhYoAbB2bQBPZmETXFgGQzf9PQi-BhbPQ2VdSSJ4aPo-FpNVA9y-7JizSgakOYeJ4KnIbcIV1cblXrqX7yIXxuJs6A
```

Now, go to Jenkins and create a secret for k8s

    Dashboard > Manage Jenkins > Credentials > System > Global credentials (unrestricted)
Create a ```secret text```credentails for K8s.
![alt text](image-17.png)

make sure, ```Kubectl``` is installed on ```Jenkins```, if not then use the following command to install it.
```bash
sudo snap install kubectl --classic
```

Apend in the pipeline as below
```sh
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mrbalraj007/FullStack-Blogging-App.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-App -Dsonar.projectKey=Blogging-App \
                      -Dsonar.java.binaries=target'''
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"  
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker build -t balrajsi/bloggingapp:latest ."  
                }
              }
            }
        }
         stage('Trivy image Scan') {
            steps {
                sh "trivy image --format table -o image.html balrajsi/bloggingapp:latest"
            }
        }
         stage('Docker Push Image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker push balrajsi/bloggingapp:latest"  
                }
              }
            }
        }
        stage('K8s-Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://DDC0F8028C6233417C293B1185142548.gr7.us-east-1.eks.amazonaws.com') {
                   sh "kubectl apply -f deployment-service.yml"
                   sleep 30
                 }
            }
        }
        stage('Verify the Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://DDC0F8028C6233417C293B1185142548.gr7.us-east-1.eks.amazonaws.com') {
                   sh "kubectl get pods"
                   sh "kubectl get svc"
                 }
            }
        }
        
        
    }
}
```

Run the pipeline
![alt text](image-19.png)

## <span style="color: yellow;"> Add the email notification.</span>

will add the following text in the pipeline.
```bash
post {
    always {
        script {
            def jobName = env.JOB_NAME
            def buildNumber = env.BUILD_NUMBER
            def pipelineStatus = currentBuild.result ?: "UNKNOWN"
            def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
            def body = """
                <html>
                    <body>
                        <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                            <h2>${jobName} - Build ${buildNumber}</h2>
                            <div style="background-color: ${bannerColor}; padding: 10px;">
                                <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                            </div>
                            <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                        </div>
                    </body>
                </html>
            """
            emailext (
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                body: body,
                to: "raj10ace@gmail.com",   # Type your email ID
                from: "jenkins@example.com",
                replyTo: "jenkins@example.com",
                mimeType: 'text/html'
            )
        }
    }
}
```
By using this Url you need to generate a app password
```bash
https://myaccount.google.com/apppasswords
```

Configure email notification in Jenkins.
    Dashboard
    Manage Jenkins
    System
![alt text](image-20.png)
click on ```test configuration```
now, configure ```Extended E-mail Notification ```
![alt text](image-21.png)

here is the complete pipeline
```sh
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mrbalraj007/FullStack-Blogging-App.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-App -Dsonar.projectKey=Blogging-App \
                      -Dsonar.java.binaries=target'''
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"  
              }
            }
        }
        stage('Docker Build and Tag') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker build -t balrajsi/bloggingapp:latest ."  
                }
              }
            }
        }
         stage('Trivy image Scan') {
            steps {
                sh "trivy image --format table -o image.html balrajsi/bloggingapp:latest"
            }
        }
         stage('Docker Push Image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker push balrajsi/bloggingapp:latest"  
                }
              }
            }
        }
        stage('K8s-Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://DDC0F8028C6233417C293B1185142548.gr7.us-east-1.eks.amazonaws.com') {
                   sh "kubectl apply -f deployment-service.yml"
                   sleep 30
                 }
            }
        }
        stage('Verify the Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'balraj-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://DDC0F8028C6233417C293B1185142548.gr7.us-east-1.eks.amazonaws.com') {
                   sh "kubectl get pods"
                   sh "kubectl get svc"
                 }
            }
        }
        
        
    }
    post {
    always {
        script {
            def jobName = env.JOB_NAME
            def buildNumber = env.BUILD_NUMBER
            def pipelineStatus = currentBuild.result ?: "UNKNOWN"
            def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
            def body = """
                <html>
                    <body>
                        <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                            <h2>${jobName} - Build ${buildNumber}</h2>
                            <div style="background-color: ${bannerColor}; padding: 10px;">
                                <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                            </div>
                            <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                        </div>
                    </body>
                </html>
            """
            emailext (
                subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                body: body,
                to: "raj10ace@gmail.com",   
                from: "jenkins@example.com",
                replyTo: "jenkins@example.com",
                mimeType: 'text/html'
            )
        }
    }
  }
}
```
email notification
![alt text](image-22.png)

pipeline view:
![alt text](image-23.png)

We will try access LB and see deployment is succesfull or not.
![alt text](image-24.png)

application is accessible now.
![alt text](image-25.png)


will create a temp user and password and login with that user credentail
![alt text](image-26.png)
clink on ```add post```
![alt text](image-27.png)

# Custom Domain



# configuring monitoring(Grafana).
```bash
http://44.201.170.60:3000/login
```
default login password for grafana is ```admin/admin```
![alt text](image-28.png)



# to download Prometheus
https://github.com/prometheus/prometheus/releases/download/v2.54.0/prometheus-2.54.0.linux-amd64.tar.gz


tar -xvf prometheus-2.54.0.linux-amd64.tar.gz

rm prometheus-2.54.0.linux-amd64.tar.gz
mv prometheus-2.54.0.linux-amd64 prometheus


# To download black box
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz

tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz
mv blackbox_exporter-0.25.0.linux-amd64/ blackbox


Now, run the following command for prometheus
```bash
ubuntu@ip-172-31-80-196:~$ cd prometheus/
ubuntu@ip-172-31-80-196:~/prometheus$ ls
LICENSE  NOTICE  console_libraries  consoles  prometheus  prometheus.yml  promtool
ubuntu@ip-172-31-80-196:~/prometheus$ ./prometheus &
```

Tyr to open 
http://44.201.170.60:9090/
![alt text](image-29.png)


Now, run the following command for blackbox
```bash
ubuntu@ip-172-31-80-196:~$ ls
blackbox  prometheus
ubuntu@ip-172-31-80-196:~$ pwd
/home/ubuntu
ubuntu@ip-172-31-80-196:~$
ubuntu@ip-172-31-80-196:~$ pwd
/home/ubuntu
ubuntu@ip-172-31-80-196:~$ cd blackbox/
ubuntu@ip-172-31-80-196:~/blackbox$ ls
LICENSE  NOTICE  blackbox.yml  blackbox_exporter
ubuntu@ip-172-31-80-196:~/blackbox$ ./blackbox_exporter &
```
Tyr to open 
http://44.201.170.60:9115/

![alt text](image-30.png)

Open this repo for [blackbox_exporter](https://github.com/prometheus/blackbox_exporter)

Need to add the following config file in ```prometheus.yml```
```bash
 - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://prometheus.io    # Target to probe with http.
        - https://prometheus.io   # Target to probe with https.
        - http://example.com:8080 # Target to probe with http on port 8080.
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115
```

![alt text](image-31.png)

## <span style="color: Yellow;">Verifying the cluster</span>
```
kubectl cluster-info
kubectl get nodes
```


## <span style="color: Yellow;">To destroy the setup using Terraform.</span>
First go to your ```Terrform``` EC2 VM and delete the EKS cluster
```bash
terraform destroy --auto-approve
```
then go to your directory on main folder ```"Terraform_Code"``` directory then run the command 
```bash
terraform destroy --auto-approve
```


## <span style="color: Yellow;">Conclusion </span>
In this blog, we’ve covered the essential steps for deploying and monitoring a Kubernetes application using Jenkins and various supporting tools. By following this guide, you can set up a robust pipeline, ensure your application is deployed smoothly, and monitor its performance effectively.

__Key Takeaways__:

Set up and configure an EKS cluster and kubectl.
Define and execute Jenkins pipelines for deployment.
Configure email notifications for deployment status.
Set up and test custom domain mapping.
Install and configure monitoring tools like Prometheus, Blackbox Exporter, and Grafana.




__Ref Link__: 

[1. CICD Pipeline Project](https://www.youtube.com/watch?v=kWON8yc6efU&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=73)  

[2. Send Email Notifications from Jenkins | Jenkins](https://www.youtube.com/watch?v=Vwo8zV8zmQU&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=71)

[3. Sign in with app passwords](https://support.google.com/mail/answer/185833?hl=en)

[4. Download Prometheus](https://prometheus.io/download/)

