
# <span style="color: Yellow;"> Automated AWS DevOps CI/CD Pipeline for Amazon Prime Clone</span>

![Amazon_Prime_Clone project](https://github.com/user-attachments/assets/f8859285-eb80-48df-8279-fc13c59ade0b)

In today’s fast-paced tech world, automating application deployment and infrastructure management is crucial. This project demonstrates how to set up a complete CI/CD pipeline, use AWS EKS for Kubernetes deployment, and integrate Grafana and Prometheus for monitoring, all using Terraform for infrastructure management. By automating everything, you reduce the need for manual intervention and improve the speed and reliability of your deployments.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - from k8s_setup_file/main.tf (i.e ```balraj```*).
  - from Virtual machine main.tf (i.e keyname- ```MYLABKEY```*)

- [x] [App Repo (Simple-DevOps-Project)](https://github.com/mrbalraj007/Amazon-Prime-Clone-Project.git)


- [x] __AWS Account__: You’ll need an AWS account to create resources like EC2 instances, EKS clusters, and more.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Basic Kubernetes (EKS)__: A basic understanding of Kubernetes, especially Amazon EKS, to deploy and manage containers.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __Grafana & Prometheus__: Understanding of these tools to monitor applications and track performance.
- [x] __Jenkins__: Knowledge of Jenkins for building and automating the CI/CD pipeline.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and the EKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> ```EKS cluster``` creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: brown;">EC2 machines will be created named as ```"Jenkins-svr"```
- &rArr;<span style="color: brown;"> Jenkins Install
- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Trivy Install
- &rArr;<span style="color: brown;"> helm Install
- &rArr;<span style="color: brown;"> Grafan Install using Helm
- &rArr;<span style="color: brown;"> Prometheus Install using Helm
- &rArr;<span style="color: brown;"> AWS Cli Install
- &rArr;<span style="color: brown;"> Terraform Install
- &rArr;<span style="color: brown;"> EKS Cluster Setup

### <span style="color: Yellow;"> EC2 Instances creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
dar--l          13/12/24  11:23 AM                All_Pipelines
dar--l          12/12/24   4:38 PM                k8s_setup_file
dar--l          11/12/24   2:48 PM                scripts
-a---l          11/12/24   2:47 PM            507 .gitignore
-a---l          13/12/24   9:00 AM           7238 main.tf
-a---l          11/12/24   2:47 PM           8828 main.txt
-a---l          11/12/24   2:47 PM           1674 MYLABKEY.pem
-a---l          11/12/24   2:47 PM            438 variables.tf
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

dar--l          13/12/24  11:23 AM                All_Pipelines
dar--l          12/12/24   4:38 PM                k8s_setup_file
dar--l          11/12/24   2:48 PM                scripts
-a---l          11/12/24   2:47 PM            507 .gitignore
-a---l          13/12/24   9:00 AM           7238 main.tf
-a---l          11/12/24   2:47 PM           8828 main.txt
-a---l          11/12/24   2:47 PM           1674 MYLABKEY.pem
-a---l          11/12/24   2:47 PM            438 variables.tf
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
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/cloud-init-output.log).
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- *If the user_data script runs successfully, you will see output logs and any errors encountered during execution.*
- *If there’s an error, this log will provide clues about what failed.*

Outcome of "```cloud-init-output.log```"

- From Terraform:
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

On the ```jenkins``` virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
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
*The ```aws eks update-kubeconfig``` command is used to configure your local kubectl tool to interact with an Amazon EKS (Elastic Kubernetes Service) cluster. It updates or creates a kubeconfig file that contains the necessary authentication information to allow kubectl to communicate with your specified EKS cluster.*

<span style="color: Orange;"> What happens when you run this command:</span><br>
The AWS CLI retrieves the required connection information for the EKS cluster (such as the API server endpoint and certificate) and updates the kubeconfig file located at ```~/.kube/config (by default)```.
It configures the authentication details needed to connect kubectl to your EKS cluster using IAM roles.
After running this command, you will be able to interact with your EKS cluster using kubectl commands, such as ```kubectl get nodes``` or ```kubectl get pods```.

```sh
kubectl get nodes
kubectl cluster-info
kubectl config get-contexts
```
![image-3](https://github.com/user-attachments/assets/4818cf2e-c970-4309-96e3-84d3a7ccd7a7)

## <span style="color: yellow;"> Setup the Jenkins </span>
Go to Jenkins EC2 and run the following command 
Access Jenkins via ```http://<your-server-ip>:8080```. 

- Retrieve the initial admin password using:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![image-4](https://github.com/user-attachments/assets/1fc5315b-0fe1-4a5a-bb7c-fd20645adbb4)
![image-5](https://github.com/user-attachments/assets/82ae7f28-7cae-476e-99ae-b1d1596c379e)
![image-6](https://github.com/user-attachments/assets/c966a1b3-96a2-4dc6-8329-a3b8f4ee93e3)
![image-7](https://github.com/user-attachments/assets/867887a1-9d3e-4d22-b37f-b63fac896620)
![image-8](https://github.com/user-attachments/assets/fc64c254-8d92-4e20-9ce0-76b1938a466a)

### <span style="color: cyan;"> Install plugin in Jenkins </span>
```sh
Manage Jenkins > Plugins view> Under the Available tab, plugins available for download from the configured Update Center can be searched and considered:
```
Following plugin needs to be installed.
```sh
SonarQube Scanner
NodeJS
Pipeline: Stage View
Blue Ocean
Eclipse Temurin installer
Docker
Docker Commons
Docker Pipeline
Docker API
docker-build-step
Prometheus metrics
```
**Note**&rArr; Restart the jenkins to make it effective plugin.

####  <span style="color: cyan;"> Create ```Webhook``` in SonarQube
    - <publicIPaddressofJenkins:9000>
- Click on 
  - Administration>Configuration>webooks
  - **Name**: sonarqube-webhook
  - **URL**: <publicIPaddressofJenkins:8080/sonarqube-webhook>
  
![image](https://github.com/user-attachments/assets/58a28ce3-63d1-42ec-8874-9f36f9644626)


####  <span style="color: cyan;"> Create a token in SonarQube
  - Administration>Security>Users>Create a new token
  
![image-1](https://github.com/user-attachments/assets/84265e50-bc10-4959-aee9-36179c2b99ab)


####  <span style="color: yellow;"> Configure Sonarqube credential in Jenkins</span>.
```
Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
```
![image-2](https://github.com/user-attachments/assets/8006669a-95c0-4d4c-b7cc-1a9cac571b8f)

####  <span style="color: yellow;"> Configure AWS credential (Access & Secret Keys) in Jenkins
```
Dashboard> Manage Jenkins> Credentials> System> Global credentials (unrestricted)
```
![image-3](https://github.com/user-attachments/assets/8c75778c-dd17-493f-a30b-c9159f8bfc51)



####  <span style="color: cyan;"> Configure/Integrate SonarQube in Jenkins</span>
```
Dashboard > Manage Jenkins > System
```
![image-4](https://github.com/user-attachments/assets/16476494-db0c-4874-a2d7-0842194c69de)
![image-5](https://github.com/user-attachments/assets/95aedde7-ac31-46c3-a216-f47d6c3c38a6)

####  <span style="color: cyan;"> Configure JDK , Sonar scanner, and Node JS</span>
- To configure ```JDK```
```
Dashboard> Manage Jenkins> Tools
```

![image-6](https://github.com/user-attachments/assets/56d3dc2f-2266-4962-a721-d7fae610a4f1)
![image-7](https://github.com/user-attachments/assets/bc2a089a-8195-47c3-a1f6-a144d90a809b)


- To configure ```SonarQube Scanner```
```
Dashboard > Manage Jenkins > Tools
```
![image-8](https://github.com/user-attachments/assets/8a13ea7c-1abf-44d9-a063-55728ccf0593)
![image-9](https://github.com/user-attachments/assets/aed870a7-3ffc-4ca2-b519-26073d0cae83)


- To configure ```Node JS```
```
Dashboard > Manage Jenkins > Tools
```
![image-10](https://github.com/user-attachments/assets/3db3803b-c349-46ec-bcd2-db6e5a17f3c3)
![image-11](https://github.com/user-attachments/assets/83fe1fef-ea25-48b0-99fb-02d97692e9f8)

<span style="color: Red;"> **Note**</span> &rArr; We have to select ```NodeJS 16.20.0``` as per project required. it won't work on ```NodeJs23.x```

- To configure ```Docker```
```
Dashboard > Manage Jenkins > Tools
```
![image-12](https://github.com/user-attachments/assets/47e5d12a-1824-47fa-b31b-eb5479ad24f2)

#### <span style="color: orange;">  Build a pipeline.</span>

  - Here is the [Pipeline Script](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/All_Pipelines/Pipeline_CI.md)

- Build deployment pipeline.
![image-23](https://github.com/user-attachments/assets/03539b39-05cc-4dea-9b7b-55efb973aaed)

Run the pipeline; the first time it would fail, and rerun it with parameters.

- I ran the pipeline but it failed with below error message.

![image-13](https://github.com/user-attachments/assets/3fba5e83-e1e7-4ac3-b34f-673a1993cf29)

**Solution:**
```sh
sudo su - ansadmin
sudo usermod -aG docker $USER && newgrp docker
sudo usermod -aG docker jenkins && newgrp docker
```
*I ran the pipeline but it failed with same error message and I found the below solution.*

**Solution:** 

jenkins service need to be restarted.
```bash
sudo systemctl restart jenkins
```

I reran the pipeline, and it went well, and the build got completed successfully.

![image-14](https://github.com/user-attachments/assets/ca86d4ef-46fc-4ba1-a88d-60107e3cac98)
![image-15](https://github.com/user-attachments/assets/b19d88d8-6d43-4e64-976b-4e96ac8f22f8)

Build status: 
![image-17](https://github.com/user-attachments/assets/edf600a9-5c5e-46af-91f3-e88d49399639)
![image-18](https://github.com/user-attachments/assets/62642045-c71a-4da7-8c92-60a6affdc629)

- Application status in SonarQube
![image-16](https://github.com/user-attachments/assets/c6beb945-6313-48ae-bc2c-ad472d62fe23)

**Quality Gate** Status is failed because of NodeJS mismatch version, as I was using the latest version of Nodes (23.x).
![image-19](https://github.com/user-attachments/assets/9d2b3aab-1517-4a36-a82d-0b08b08bba5f)

- I removed the nodes js 23.x and installed ```nodejs16```.
- <span style="color: red;">**Note: &rArr; You won't be facing this issue because I have updated the Terraform code.**</span>
```sh
sudo apt-get remove -y nodejs

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Rerun the pipeline and change the quality gate status to passed from failed.
![image-20](https://github.com/user-attachments/assets/02a8781d-b56c-4faa-af35-b409e6052e5b)


```sh
Cleanup Old Images from ECR checks if there are more than 3 images in the repository and deletes the old ones if necessary.
```

![image-21](https://github.com/user-attachments/assets/8f136fc5-ae7f-4f29-8233-7f9486ed2fcb)

![image-22](https://github.com/user-attachments/assets/a9278715-e84b-4320-a03a-9225dcfd15ab)

### <span style="color: orange;"> Setup ArgoCD </span>

- Run the following commands to verify the ```Pods``` and ```services type```

```sh
kubectl get pods -n argocd
kubectl get svc -n argocd

kubectl get pods -n prometheus
kubectl get service -n prometheus
```

```sh
ubuntu@bootstrap-svr:~$ kubectl get pods -n argocd
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          40m
argocd-applicationset-controller-64f6bd6456-79k4l   1/1     Running   0          40m
argocd-dex-server-5fdcd9df8b-85dl7                  1/1     Running   0          40m
argocd-notifications-controller-778495d96f-lsmww    1/1     Running   0          40m
argocd-redis-69fd8bd669-qd4qs                       1/1     Running   0          40m
argocd-repo-server-75567c944-cwrdv                  1/1     Running   0          40m
argocd-server-5c768cdd96-wh4t5                      1/1     Running   0          40m

ubuntu@bootstrap-svr:~$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   172.20.37.85     <none>        7000/TCP,8080/TCP            41m
argocd-dex-server                         ClusterIP   172.20.185.246   <none>        5556/TCP,5557/TCP,5558/TCP   41m
argocd-metrics                            ClusterIP   172.20.6.170     <none>        8082/TCP                     41m
argocd-notifications-controller-metrics   ClusterIP   172.20.36.121    <none>        9001/TCP                     41m
argocd-redis                              ClusterIP   172.20.104.129   <none>        6379/TCP                     41m
argocd-repo-server                        ClusterIP   172.20.184.189   <none>        8081/TCP,8084/TCP            41m
argocd-server                             ClusterIP   172.20.150.224   <none>        80/TCP,443/TCP               41m
argocd-server-metrics                     ClusterIP   172.20.208.97    <none>        8083/TCP                     41m
ubuntu@bootstrap-svr:~$

```

```sh
ubuntu@bootstrap-svr:~$ kubectl get pods -n prometheus
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-stable-kube-prometheus-sta-alertmanager-0   2/2     Running   0          42m
prometheus-stable-kube-prometheus-sta-prometheus-0       2/2     Running   0          42m
stable-grafana-6c67f4cb8d-k4bpb                          3/3     Running   0          42m
stable-kube-prometheus-sta-operator-74dcfb4f9c-2vwqr     1/1     Running   0          42m
stable-kube-state-metrics-6d6d5fcb75-w8k4l               1/1     Running   0          42m
stable-prometheus-node-exporter-8tqgh                    1/1     Running   0          42m
stable-prometheus-node-exporter-jkkkf                    1/1     Running   0          42m

ubuntu@bootstrap-svr:~$ kubectl get service -n prometheus
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   42m
prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     42m
stable-grafana                            ClusterIP   172.20.21.160   <none>        80/TCP                       42m
stable-kube-prometheus-sta-alertmanager   ClusterIP   172.20.20.12    <none>        9093/TCP,8080/TCP            42m
stable-kube-prometheus-sta-operator       ClusterIP   172.20.69.94    <none>        443/TCP                      42m
stable-kube-prometheus-sta-prometheus     ClusterIP   172.20.199.20   <none>        9090/TCP,8080/TCP            42m
stable-kube-state-metrics                 ClusterIP   172.20.52.146   <none>        8080/TCP                     42m
stable-prometheus-node-exporter           ClusterIP   172.20.40.154   <none>        9100/TCP                     42m
```

- Run these commands to change the service type from ```ClusterIP``` to ```LoadBalancer```.
```sh
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
Verify status now.
![image-24](https://github.com/user-attachments/assets/7d359db7-4768-4a07-9f8d-77c37a2b6df5)


- Now, time to run the script to get ArgoCD and Grafana access details.

[Here is the access script](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/All_Pipelines/access.sh)

Once you access the ArgoCD URL and create an application
 - **Application Name**: amazon-prime-app
 - **Project Name**: default
 - **Sync Policy**: Automatic (Select Prune Resources and SelfHeal)
 - **Repository URL**: https://github.com/mrbalraj007/Amazon-Prime-Clone-Project.git
 - **Revison**: main
 - **Path**: k8s_files (where Kubernetes files reside)
 - **cluster URL**: Select default cluster
 - **Namespace**: default

![image-25](https://github.com/user-attachments/assets/4caad6f2-dc55-4267-96dc-ea717f9effb8)
![image-26](https://github.com/user-attachments/assets/a820c29f-8547-4b5e-9186-5e48acdb9d5f)

- Update the **latest image** name in ```deployment.yml```
![image-27](https://github.com/user-attachments/assets/47134897-c0c0-4cda-949b-ef94f38150bd)

**Verify the apps Status**
![image-28](https://github.com/user-attachments/assets/9c25274d-5464-476e-bfdb-9eddcce21975)

**Verify Pods & service status**
![image-29](https://github.com/user-attachments/assets/39589d65-4cd4-480c-b5c6-a59fdc341b50)

Click on the hostnames (URL details) from the service and access it in the browser.
```
http://af70e2590416f4788be765b667bb8175-2006799998.us-east-1.elb.amazonaws.com:3000/
```

![image-30](https://github.com/user-attachments/assets/c78e077f-0457-4468-a69a-b71a4a73af2d)


Congratulations :-) the application is working and accessible.
![image-31](https://github.com/user-attachments/assets/70dc9605-5650-43ed-bd06-2c035abcb843)

- Access Prometheus/Grafana and create a custom dashboard in Prometheus/Grafana.
  
![image-32](https://github.com/user-attachments/assets/452104dd-c859-46cd-909a-c53345055cab)
![image-33](https://github.com/user-attachments/assets/5f96e4af-4b06-49f8-9eae-a22b1c60ba04)
![image-34](https://github.com/user-attachments/assets/b54fcf5d-98fe-4196-8c6d-d66b154af843)
![image-35](https://github.com/user-attachments/assets/c0b83f08-4fdc-4f9b-b1cf-8d562918b806)

Dashboard in Grafana
![image-36](https://github.com/user-attachments/assets/ec873ad5-ed0c-43b4-9d85-2a08e16a5839)

### <span style="color: yellow;"> Cleanup the images and deployment using the pipeline.</span>

- Here is the [Updated pipeline](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/All_Pipelines/Cleanup.md)

![image-37](https://github.com/user-attachments/assets/86abb97d-3a99-4ca4-afde-3334ecf4a795)

*Pipeline would be partially failed because KMS will take some days to get it deleted automatically.*
![image-38](https://github.com/user-attachments/assets/fa32f024-1db8-442e-9fcf-51cecc74d301)

- Verify the pods and services in EKS. If it is not deleted, then change the service back to ClusterIP and rerun the pipeline.

```sh
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc singh-app -p '{"spec": {"type": "ClusterIP"}}'
```
<!-- 

```sh
Verify the Outputs in the EKS Module: Check the documentation or code for the terraform-aws-modules/eks/aws module version 19.15.1 you are using. The correct output might not be cluster_id but something else like eks_cluster_id, cluster_name, etc.

To confirm:

Look into .terraform/modules/eks/outputs.tf.
Identify the exact name of the output variable for the cluster name.
```


```sh
Run the following command outside the Jenkins pipeline to verify connectivity and status:
bash
Copy code
aws eks --region us-east-1 describe-cluster --name balraj-cluster
``` -->


## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

- __Delete all deployment/Service__ first
    - ```sh
        kubectl delete deployment.apps/singh-app
        kubectl delete service singh-app
        kubectl delete service/singh-service
        ```
   - __```EKS cluster```__ second
   - then delete the __```virtual machine```__.




#### To delete ```AWS EKS cluster```
   -   Login into the bootstrap EC2 instance and change the directory to /k8s_setup_file, and run the following command to delete the cluste.
```bash
sudo su - ubuntu
cd /k8s_setup_file
sudo terraform destroy --auto-approve
```



#### Now, time to delete the ```Virtual machine```.
Go to folder *<span style="color: cyan;">"19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion

By combining Terraform, Jenkins, EKS, Docker, and monitoring tools like Grafana and Prometheus, this project automates the entire process of infrastructure management, application deployment, and monitoring. The use of a cleanup pipeline ensures that resources are removed when no longer needed, helping to reduce costs. This approach offers a scalable, efficient, and cost-effective solution for modern application deployment and management.


__Ref Link:__

- [Youtube VideoLink](https://www.youtube.com/watch?v=Gd9Aofx-iLI&t=7808s)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [EKS Create-repository](https://docs.aws.amazon.com/cli/latest/reference/ecr/create-repository.html)

- [EKS describe-repositories](https://docs.aws.amazon.com/cli/latest/reference/ecr/describe-repositories.html)

- [AWS configure](https://docs.aws.amazon.com/cli/latest/reference/configure/set.html)

- [Jenkins-environment-variables-1](https://phoenixnap.com/kb/jenkins-environment-variables)
- [Jenkins-environment-variables-2](https://devopsqa.wordpress.com/2019/11/19/list-of-available-jenkins-environment-variables/)
