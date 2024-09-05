# <span style="color: Yellow;"> Deploying microservices to a Kubernetes cluster with CI/CD: A Step-by-Step Guide </span>
In this blog post, we’ll walk you through the process of deploying a Kubernetes application using Jenkins. This guide will help you set up a CI/CD pipeline for deploying microservices to a Kubernetes cluster. We’ll cover creating roles, binding them to service accounts, and setting up a Jenkins pipeline for automation.

## <span style="color: Yellow;"> Prerequisites </span>
  
- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/09.Real-Time-DevOps-Project/Terraform_Code/04.Code_IAC_Terraform_box) 
- [x] [App Repo](https://github.com/mrbalraj007/Microservice)
- [x] __Jenkins Installation__: Ensure Jenkins is installed and running.
- [x] __Kubernetes Cluster__: Have a Kubernetes cluster set up and accessible.
- [x] __Kubernetes CLI (kubectl)__: Install and configure kubectl on your system.
- [x] __Jenkins Kubernetes Plugin__: Install the Kubernetes plugin for Jenkins to enable Kubernetes integration.
- [x] __Service Account__: Create a Kubernetes service account with appropriate roles and permissions.
- [x] __Token Generation__: Generate a token for the service account to be used by Jenkins for authentication.



## <span style="color: Yellow;"> Key Points
- __Create a Kubernetes Role__: Define permissions for resources.
- __Bind Role to Service Account__: Assign permissions to the service account.
- __Generate and Use a Token__: Authenticate the service account.
- __Set Up Jenkins Pipeline__: Automate deployment and verification.

## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform file to set up the entire environment, including the installation of required applications, tools, and the EKS cluster automatically created.

<!-- - [x] Setting Up the Virtual Machines (EC2)

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"09.Real-Time-DevOps-Project/Terraform_Code/04.Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/08/24   9:48 AM                04.Code_IAC_Terraform_box
```

<!-- __<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from outside the folders; do not go inside the folders.

```bash
cd 09.Real-Time-DevOps-Project/Terraform_Code/04.Code_IAC_Terraform_box"

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          02/09/24  12:10 PM                .terraform
da---l          02/09/24   5:59 PM                k8s_setup_file
-a---l          21/08/24   2:56 PM            500 .gitignore
-a---l          04/09/24   7:08 PM           6965 main.tf
-a---l          04/09/24   7:18 PM           4184 terrabox_install.sh
```
You need to run ```main.tf``` file using following terraform command.

#### Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
``` -->
-------
### __Environment Setup__
|HostName|OS|
|:----:|:----:|
|terrabox-svr| Ubuntu 24 LTS|

> * Password for the **root** account on all these virtual machines is **xxxxxxx**
> * Perform all the commands as root user unless otherwise specified

![alt text](image-23.png)

<details><summary><b><span style="color: Orange;">Change the hostname: (optional)</b></summary><br>

sudo terraform show


```bash
sudo hostnamectl set-hostname Jenkins
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
Notedown the public address of the VM and access it in browser
```bash
<publicIP of VM :8080>
```
![alt text](image.png)

will run this command on VM ```sudo cat /var/lib/jenkins/secrets/initialAdminPassword``` to get the first time password.

![alt text](image-1.png)


<!-- eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster balraj-cluster \
    --approve -->

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
  
![alt text](image-2.png)

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

![alt text](image-3.png)

### <span style="color: cyan;"> Creating a multipipeline in Jenkins:</span>

> name: microservice-ecommerce
> 
> item type: Multibranch pipeline
> 
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)

Syntax to configure the __webhooks__ in ```github``` 
```JENKINS_URL/multibranch-webhook-trigger/invoke?token=[Trigger token]```
```bash
http://18.234.174.99:8080/multibranch-webhook-trigger/invoke?token=singh
```
go to github repo > setting> webhooks
![alt text](image-7.png)
![alt text](image-8.png)

Once you configure __webhook__ then build the pipeline and you will see successfull build.
![alt text](image-9.png)

- Images view from ```Docker Hub```
![alt text](image-10.png)

## <span style="color: yellow;"> Setup the EKS Cluster </span>
On the virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
```sh
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ pwd
/home/ubuntu/k8s_setup_file
ubuntu@ip-172-31-90-126:~/k8s_setup_file$
```
Once EKS cluster is setup then need to run the following command to make it intract with EKS.

```sh
aws eks update-kubeconfig --name <cluster-name> --region 
<region>
```
The ```aws eks update-kubeconfig``` command is used to configure your local kubectl tool to interact with an Amazon EKS (Elastic Kubernetes Service) cluster. It updates or creates a kubeconfig file that contains the necessary authentication information to allow kubectl to communicate with your specified EKS cluster.

#### <span style="color: Orange;"> What happens when you run this command:</span>
The AWS CLI retrieves the required connection information for the EKS cluster (such as the API server endpoint and certificate) and updates the kubeconfig file located at ~/.kube/config (by default).
It configures the authentication details needed to connect kubectl to your EKS cluster using IAM roles.
After running this command, you will be able to interact with your EKS cluster using kubectl commands, such as ```kubectl get nodes``` or ```kubectl get pods```.


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

![alt text](image-12.png)

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
![alt text](image-13.png)

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
![alt text](image-14.png)


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
![alt text](image-15.png)

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
![alt text](image-16.png)

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

![alt text](image-18.png)

Finally, set up a Jenkins pipeline to automate deployment:

Create a ```dummy Jenkins Pipeline```: Define stages for deployment and verification.

![alt text](image-17.png)

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
![alt text](image-19.png)

Commit and Run: Commit the Jenkinsfile and let Jenkins pick it up. Monitor the deployment process and check the application URL once it’s up and running.

![alt text](image-21.png)

## <span style="color: Yellow;"> Deployment Verification

- Once the pipeline is set up, Jenkins will deploy the microservices and provide a URL to access the application.

![alt text](image-22.png)

- will browser the LB URL and website should be accessible.
![alt text](image-20.png)

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete the EKS cluster first, then delete the virtual machine.
```bash
terraform destroy --auto-approve
```

- To clean up, delete the Kubernetes cluster with ```eksctl delete cluster --name <cluster-name> --region <region>```.


##### <span style="color: Yellow;"> *I got below error message while deleting the EKS cluster; you may be experiencing the same, so the solution is to ```manually delete the load balancer``` in the AWS console and ```delete the VPC```.*

![alt text](image-24.png)


#### Now, time to delete the Virtual machine.

Go to folder *<span style="color: cyan;">"09.Real-Time-DevOps-Project/Terraform_Code/04.Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/08/24   9:48 AM                04.Code_IAC_Terraform_box



Terraform destroy --auto-approve
```


## <span style="color: Yellow;"> Key Takeaways
- __Automation__: The pipeline automates the deployment process, making it easier to manage multiple microservices.
- __Flexibility__: The use of Jenkins and Kubernetes allows for flexible and scalable deployment strategies.
- __Efficiency__: Implementing automated CI/CD pipelines improves deployment speed and reliability.
## <span style="color: Yellow;"> What to Avoid
- __Hardcoding Secrets__: Avoid hardcoding sensitive information like tokens in your pipeline scripts. Use Jenkins credentials and Kubernetes secrets.
- __Long Sleep Periods__: Instead of using long sleep periods in your pipeline, consider using appropriate Kubernetes checks to confirm the status of deployments.
## <span style="color: Yellow;"> Key Benefits
- __Streamlined Deployment__: Automates the deployment of multiple microservices with minimal manual intervention.
- __Improved Efficiency__: Reduces deployment time and ensures consistency across environments.
- __Scalability__: Easily scales to handle large numbers of microservices and complex deployment scenarios.


## <span style="color: Yellow;"> Conclusion

By following these steps and best practices, you can efficiently set up a CI/CD pipeline that enhances your deployment processes and streamlines your workflow.

Following these steps, you can successfully deploy and manage a Kubernetes application using Jenkins. Automating this process with Jenkins pipelines ensures consistent and reliable deployments.
If you found this guide helpful, please like and subscribe to my blog for more content. Feel free to reach out if you have any questions or need further assistance!


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=SO3XIJCtmNs&t=498s "11 Microservice CICD Pipeline DevOps Project | Ultimate DevOps Pipeline")
- [End-to-End Multibranch Pipeline Project Creation](https://www.jenkins.io/doc/tutorials/build-a-multibranch-pipeline-project/)
- [Jenkins Multibranch Pipeline With Git Tutorial](https://www.cloudbees.com/blog/jenkins-multibranch-pipeline-with-git-tutorial)
- [Set up kubectl and eksctl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)




