# <span style="color: Yellow;"> Prometheus and Grafana on Kubernetes with ArgoCD</span>

This guide will help you set up Prometheus and Grafana on Kubernetes with ArgoCD, ideal for both beginners and experienced DevOps professionals. The project focuses on monitoring Kubernetes clusters using Prometheus (for metrics collection) and Grafana (for visualizing those metrics). We'll also briefly cover ArgoCD for continuous delivery and how to integrate these tools to create a robust observability platform.

## <span style="color: Yellow;"> Prerequisites for This Project </span>
 
Before starting, make sure you have the following ready:
- [x] [Terraform Code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/11.Real-Time-DevOps-Project/Terraform_Code) 
- [x] [App Code Repo](https://github.com/mrbalraj007/starbucks.git)
- [x] __Kubernetes Cluster__: A working Kubernetes cluster (KIND cluster or any managed Kubernetes service like EKS or GKE).
- [x] __Docker Installed__: To run KIND clusters inside Docker containers.
- [x] __Basic Understanding of Kubernetes__: Knowledge of namespaces, pods, and services.
- [x] __kubectl Installed__: For interacting with your Kubernetes cluster.
- [x] __ArgoCD Installed__: If you want to use GitOps practices for deploying applications.

## <span style="color: Yellow;"> Key Steps and Highlights</span>

Here’s what you’ll be doing in this project:

- __Port Forwarding with Prometheus__: Bind Prometheus to port 9090 and forward it to 0.0.0.0:9090. This allows you to access the Prometheus dashboard from your machine.
- __Expose Ports on Security Groups__: Open necessary ports (like 9090 for Prometheus and 3000 for Grafana) in your instance's security group to access them from outside.
- __Monitoring Services__: Verify that Kubernetes is sending data to Prometheus. You can check this in the Targets section of Prometheus.
- __PromQL Queries__: Use PromQL queries to monitor metrics like container CPU usage, network traffic, etc. You can execute these queries to analyze performance metrics.
- __Visualizing in Grafana__: After adding Prometheus as a data source in Grafana, create dashboards to visualize CPU, memory, and network usage over time.
- __Real-Time Monitoring__: Generate traffic or CPU load in your applications (like the voting app) to observe how Prometheus collects metrics and Grafana displays them.
- __Custom Dashboards__: Use pre-built Grafana dashboards by importing them through dashboard IDs, making it easier to visualize complex data without starting from scratch.


## <span style="color: Yellow;">Setting Up the Environment </span>
I have created a Terraform file to set up the entire environment, including the installation of required applications, tools, and the ArgoCD cluster automatically created.

<!-- <span style="color: cyan;"> __Note__&rArr;</span> I was using <span style="color: red;">```t3.medium```</span> and having performance issues; I was unable to run the pipeline, and it got stuck in between. So, I am now using ```t2.xlarge``` now. Also, you have to update ```your email address``` in the ```main.tf``` file so that topic for alerting can be created while creation the VM. -->

#### <span style="color: Yellow;">Setting Up the Virtual Machines (EC2)

First, we'll create the necessary virtual machines using ```terraform```. 

Below is a terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"11.Real-Time-DevOps-Project/Terraform_Code"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          10/09/24   7:32 PM                Terraform_Code
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
cd 11.Real-Time-DevOps-Project/Terraform_Code"

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---l          21/08/24   2:56 PM            500 .gitignore
-a---l          10/09/24   7:29 PM           4287 main.tf
-a---l          10/09/24   1:17 PM           3379 terrabox_install.sh
```
You need to run ```main.tf``` file using following terraform command.

#### Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```
-------
Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

#### <span style="color: cyan;"> Verify the Docker version
```bash
ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1


docker ps -a
ubuntu@ip-172-31-94-25:~$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
8436c820f163   kindest/node:v1.31.0   "/usr/local/bin/entr…"   4 minutes ago   Up 3 minutes   127.0.0.1:35147->6443/tcp   kind-control-plane
0d6ed793da0e   kindest/node:v1.31.0   "/usr/local/bin/entr…"   4 minutes ago   Up 3 minutes                               kind-worker
5146cf4dfd20   kindest/node:v1.31.0   "/usr/local/bin/entr…"   4 minutes ago   Up 3 minutes                               kind-worker2
```


#### <span style="color: Cyan;"> Inspect the ```Cloud-Init``` logs</span>: Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the log files.

```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
```
- If the user_data script runs successfully, you will see output logs and any errors encountered during execution.
- If there’s an error, this log will provide clues about what failed.


<!-- Kind Cluster Name: The Kind cluster is explicitly named kind during creation to match the context setup (--name kind).
Kubeconfig Setup: The kind get kubeconfig command exports the Kubernetes cluster configuration to the correct location (/home/ubuntu/.kube/config) and sets the KUBECONFIG environment variable so that kubectl can interact with the Kind cluster.
Permissions for Kubeconfig: The ownership of the kubeconfig file is set to the ubuntu user to ensure it can be accessed and modified properly. -->

#### <span style="color: cyan;">Testing Commands:
After Terraform deploys the instance and the cluster is set up, you can SSH into the instance and run:

```bash
kubectl get nodes
kubectl cluster-info
kubectl config get-contexts
```


## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete the environment
```bash
terraform destroy --auto-approve
```
#### <span style="color: cyan;">Time to delete the Virtual machine.

Go to folder *<span style="color: cyan;">"11.Real-Time-DevOps-Project/Terraform_Code"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          10/09/24   9:48 PM                Terraform_Code

Terraform destroy --auto-approve
```
## <span style="color: Yellow;"> Key Takeaways</span>
- __Prometheus for Metrics Collection__: It's a time-series database that scrapes data from Kubernetes services.

- __Grafana for Visualization__: Allows you to create beautiful dashboards from the metrics data stored in Prometheus.

- __Real-Time Monitoring__: You can observe real-time performance metrics for CPU, memory, and network using the dashboards.

- __GitOps with ArgoCD__: ArgoCD makes deploying and managing applications on Kubernetes easier by automating continuous deployment.

## <span style="color: Yellow;"> What to Avoid </span>
- __Incorrect Port Forwarding__: Make sure you expose the correct ports for both Prometheus (9090) and Grafana (3000). Missing this can lead to connection issues.

- __Skipping Security Groups Configuration__: Always open the necessary ports in your cloud provider's security groups. Otherwise, the services won't be accessible externally.
- __Not Using PromQL Effectively__: PromQL can seem complex, but it's essential to retrieve valuable metrics like CPU or memory usage. Avoid using generic queries without understanding the context of your services.

## <span style="color: Yellow;"> Benefits of Using This Setup</span>
- __Improved Observability__: Combining Prometheus and Grafana gives you full observability over your Kubernetes clusters.
- __Real-Time Metrics__: You can monitor your services in real-time, making troubleshooting faster and more efficient.

- __Scalability__: This setup grows with your infrastructure, allowing you to monitor large-scale deployments with ease.

- __Cost-Efficient__: Both Prometheus and Grafana are open-source, providing a cost-effective solution for monitoring.

- __Ease of Use__: With Grafana's pre-built dashboards and PromQL's flexibility, it’s easy to get started and scale monitoring solutions.


====================================**************************=================================
```sh
#!/bin/bash
sudo apt update -y
sudo apt install openjdk-17-jre-headless -y
sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip
##Install Docker and Run SonarQube as Container
sudo apt-get update
sudo apt-get install docker.io -y
# sudo usermod -aG docker ubuntu
# sudo usermod -aG docker jenkins  
# newgrp docker
sudo chmod 777 /var/run/docker.sock

# Add the current user to the docker group
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker
```

verify docker 
```sh
docker ps -a
```
install_kind.sh
```sh
#!/bin/bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
rm -rf kind
```

## config.yml

```sh
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4

nodes:
- role: control-plane
  image: kindest/node:v1.31.0
- role: worker
  image: kindest/node:v1.31.0
- role: worker
  image: kindest/node:v1.31.0
```
- ### <span style="color: Yellow;">Create a 3-node Kubernetes cluster using Kind:</span>
```sh
kind create cluster --config=config.yml --name=my-cluster
```

- #### <span style="color: Cyan;">install_kubectl.sh</span>
```sh
#!/bin/bash

# Variables
VERSION="v1.31.0"
URL="https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
INSTALL_DIR="/usr/local/bin"

# Download and install kubectl
curl -LO "$URL"
chmod +x kubectl
sudo mv kubectl $INSTALL_DIR/
kubectl version --client

# Clean up
rm -f kubectl

echo "kubectl installation complete."
```

- #### <span style="color: Cyan;">Check cluster information:</span>
```sh
kubectl get nodes
kind get clusters
kubectl cluster-info --context kind-kind
```
- ### <span style="color: yellow;">Managing Docker and Kubernetes Pods

- #### <span style="color: Cyan;">Check Docker containers running:</span>
```sh
docker ps
```
- #### <span style="color: Cyan;">List all Kubernetes pods in all namespaces:</span>
```sh
kubectl get pods -A
```

- ### <span style="color: Yellow;">Installing Argo CD</span>

- #### <span style="color: Cyan;">Create a namespace for Argo CD:
```sh
kubectl create namespace argocd
```

- #### <span style="color: Cyan;"> Apply the Argo CD manifest:
```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- #### <span style="color: Cyan;"> Check services in Argo CD namespace:
```sh
kubectl get svc -n argocd
```
- Currently, it is set to ```clusterIP``` and we will change it to ```NodePort```
- Expose Argo CD server using NodePort:
```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```

- #### <span style="color: Cyan;">Forward ports to access Argo CD server:
```sh
kubectl port-forward -n argocd service/argocd-server 8443:443 --address=0.0.0.0 &
# kubectl port-forward -n argocd service/argocd-server 8443:443 &
```
- Argo CD Initial Admin Password
- #### <span style="color: Cyan;">Retrieve Argo CD admin password:
```sh
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```
- #### <span style="color: Cyan;">Validate the pods
```sh
kubectl get pods
```
kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db           ClusterIP   10.96.35.109    <none>        5432/TCP         6m54s
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          24m
redis        ClusterIP   10.96.56.105    <none>        6379/TCP         6m54s
result       NodePort    10.96.218.76    <none>        5001:31001/TCP   6m54s
vote         NodePort    10.96.140.226   <none>        5000:31000/TCP   6m54s
dc-ops@master:~/k8s-cluster$


Now, we will do the port-forward to Vote and results
```sh
kubectl port-forward svc/vote 5000:5000 --address=0.0.0.0 &
```
```sh
kubectl port-forward svc/result 5001:5001 --address=0.0.0.0 &
```

- #### <span style="color: Cyan;">Deploy Kubernetes dashboard:
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

- dashboard-adminuser.yml
```sh
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

```sh
kubectl apply -f dashboard-adminuser.yml
```

- #### <span style="color: Cyan;">Create a token for dashboard access:
```sh
kubectl -n kubernetes-dashboard create token admin-user
```
Now, we have to port-forward to kubernets dashboard as well.
```sh
kubectl get svc -n kubernetes-dashboard

kubectl port-forward svc/kubernetes-dashboard -n kubernetes-dashboard 8080:443 --address=0.0.0.0 &
```

__Ref Link__

- [Kubernetes With ArgoCD](https://www.youtube.com/watch?v=Kbvch_swZWA&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=122 "Live DevOps Project on Kubernetes With ArgoCD For Freshers to Experienced")
- [Prometheus & Grafana Tutorial](https://www.youtube.com/watch?v=DXZUunEeHqM&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=122 "Easiest Prometheus & Grafana Tutorial For DevOps on Kubernetes")
- [Kind](https://github.com/kubernetes-sigs/kind?tab=readme-ov-file)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Kind Release version](https://github.com/kubernetes-sigs/kind/releases)





























**************TSW Commands**********************************************

# Terminal Command History for K8s Kind Voting App

## 1. Creating and Managing Kubernetes Cluster with Kind

- Clear terminal:
  ```bash
  clear
  ```

- Create a 3-node Kubernetes cluster using Kind:
  ```bash
  kind create cluster --config=config.yml
  ```

- Check cluster information:
  ```bash
  kubectl cluster-info --context kind-kind
  kubectl get nodes
  kind get clusters
  ```

---

## 2. Installing kubectl

- Download `kubectl` for managing Kubernetes clusters:
  ```bash
  curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin
  kubectl version --short --client
  ```

---

## 3. Managing Docker and Kubernetes Pods

- Check Docker containers running:
  ```bash
  docker ps
  ```

- List all Kubernetes pods in all namespaces:
  ```bash
  kubectl get pods -A
  ```

---

## 4. Cloning and Running the Example Voting App

- Clone the voting app repository:
  ```bash
  git clone https://github.com/dockersamples/example-voting-app.git
  cd example-voting-app/
  ```

- Apply Kubernetes YAML specifications for the voting app:
  ```bash
  kubectl apply -f k8s-specifications/
  ```

- List all Kubernetes resources:
  ```bash
  kubectl get all
  ```

- Forward local ports for accessing the voting and result apps:
  ```bash
  kubectl port-forward service/vote 5000:5000 --address=0.0.0.0 &
  kubectl port-forward service/result 5001:5001 --address=0.0.0.0 &
  ```

---

## 5. Managing Files in Example Voting App

- Navigate and view files:
  ```bash
  cd ..
  cd seed-data/
  ls
  cat Dockerfile
  cat generate-votes.sh
  ```

---

## 6. Installing Argo CD

- Create a namespace for Argo CD:
  ```bash
  kubectl create namespace argocd
  ```

- Apply the Argo CD manifest:
  ```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  ```

- Check services in Argo CD namespace:
  ```bash
  kubectl get svc -n argocd
  ```

- Expose Argo CD server using NodePort:
  ```bash
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
  ```

- Forward ports to access Argo CD server:
  ```bash
  kubectl port-forward -n argocd service/argocd-server 8443:443 &
  ```

---

## 7. Deleting Kubernetes Cluster

- Delete the Kind cluster:
  ```bash
  kind delete cluster --name=kind
  ```

---

## 8. Installing Kubernetes Dashboard

- Deploy Kubernetes dashboard:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
  ```

- Create a token for dashboard access:
  ```bash
  kubectl -n kubernetes-dashboard create token admin-user
  ```

---

## 9. Argo CD Initial Admin Password

- Retrieve Argo CD admin password:
  ```bash
  kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
  ```

