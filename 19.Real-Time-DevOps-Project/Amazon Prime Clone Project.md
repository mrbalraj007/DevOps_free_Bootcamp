



Webhook for SonarQube

![alt text](image.png)


Create a token for SonarQube
![alt text](image-1.png)

squ_deec0bae00e73086df96bf75ee8cb0c79d3375c5


Store Sonar credential in Jenkins.

    Dashboard
    Manage Jenkins
    Credentials
    System
    Global credentials (unrestricted)

![alt text](image-2.png)

Adding AWS credential (Access & Secret Keys)
![alt text](image-3.png)

# Setup jenkins
- install plugin

```sh

- SonarQube Scanner
- NodeJS
- Pipeline: Stage View
- Blue Ocean
- Eclipse Temurin installer
- Docker
- Docker Commons
- Docker Pipeline
- Docker API
- docker-build-step
- Prometheus metrics
```
- Restart the jenkins to make it effective.

# Configure/Integrate SonarQube in Jenkins.
    Dashboard
    Manage Jenkins
    System

![alt text](image-4.png)
![alt text](image-5.png)

- Configure JDK , Sonar scanner, and Node JS


- JDK
Dashboard
Manage Jenkins
Tools
![alt text](image-6.png)
![alt text](image-7.png)


- SonarQube Scanner
Dashboard
Manage Jenkins
Tools

![alt text](image-8.png)
![alt text](image-9.png)


- Node JS
Dashboard
Manage Jenkins
Tools
![alt text](image-10.png)
![alt text](image-11.png)
**Note**- We have to select NodeJS 16.20.0 as per project required. it wont work on NodeJs23.x

- Docker
Dashboard
Manage Jenkins
Tools
![alt text](image-12.png)


















********************************
Ensure Node.js and npm Are Installed:
```sh
Log into the server where Jenkins is running (or the agent node if using a distributed setup).
Verify if Node.js and npm are installed:
bash
Copy code
node -v
npm -v
If not installed, install Node.js and npm:
bash
Copy code
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt-get install -y nodejs
(Replace 16.x with the desired Node.js version.)
```
********************************
Pipeline Script:xxxx

first time it would be failed and rerun it with parameters.



Build Pipeline



Build failed

![alt text](image-13.png)

solution: 
```sh

sudo su - ansadmin
sudo usermod -aG docker $USER && newgrp docker
sudo usermod -aG docker jenkins && newgrp docker
```
I am still getting the error message, so I found the below solution.

Solution:  
```bash
sudo systemctl restart jenkins
```
Build successfull

![alt text](image-14.png)


![alt text](image-15.png)



Build status
![alt text](image-17.png)
![alt text](image-18.png)

SonarQube
![alt text](image-16.png)

Qualitygate status is failed because of NodeJS miss match version, as I was using latest version of Nodes (23.x)
![alt text](image-19.png)



- I need to remove the nodes js 23.x and will install nodejs16
```sh
sudo apt-get remove -y nodejs

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Now,
![alt text](image-20.png)


```sh
Cleanup Old Images from ECR, checks if there are more than 3 images in the repository and deletes the oldest ones if necessary. 
```

![alt text](image-21.png)

![alt text](image-22.png)


- Build deployment pipeline.

![alt text](image-23.png)


build it and abort it because we will use parameter.
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

run these commands
```sh
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
Output-
![alt text](image-24.png)

now, run the script (Access) to get argocd  and grannace access details.



![alt text](image-25.png)
![alt text](image-26.png)


![alt text](image-27.png)


![alt text](image-28.png)

![alt text](image-29.png)





![alt text](image-30.png)

http://af70e2590416f4788be765b667bb8175-2006799998.us-east-1.elb.amazonaws.com:3000/

![alt text](image-31.png)



- will create a custom dashboard in prometheous/Grafana
![alt text](image-32.png)
![alt text](image-33.png)
![alt text](image-34.png)
![alt text](image-35.png)

Dashboard
![alt text](image-36.png)

### Cleanup the pipeline.

![alt text](image-37.png)



It would be failed because KMS will take some days to get it deleted automatically.
![alt text](image-38.png)


```sh
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'
kubectl patch svc singh-app -p '{"spec": {"type": "ClusterIP"}}'
```







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
```

```sh
kubectl delete deployment.apps/singh-app
kubectl delete service singh-app

```













[Youtube](https://www.youtube.com/watch?v=Gd9Aofx-iLI&t=7808s)

[Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

[Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

https://docs.aws.amazon.com/cli/latest/reference/ecr/create-repository.html

https://docs.aws.amazon.com/cli/latest/reference/configure/set.html

https://docs.aws.amazon.com/cli/latest/reference/ecr/describe-repositories.html

https://phoenixnap.com/kb/jenkins-environment-variables

https://devopsqa.wordpress.com/2019/11/19/list-of-available-jenkins-environment-variables/
