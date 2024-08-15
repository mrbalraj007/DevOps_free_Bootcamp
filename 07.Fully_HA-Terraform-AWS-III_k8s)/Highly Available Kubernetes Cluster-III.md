# <span style="color: Yellow;"> Setting up a Highly available Kubernetes cluster with redundant load balancers using Keepalived and HAProxy </span>

![alt text](HA_Proxy.gif)

In this blog, we'll walk you through the process of setting up a highly available Kubernetes cluster using Keepalived and HAProxy. The goal is to eliminate the single point of failure in your Kubernetes control plane by implementing redundancy in your load balancers and ensuring that your Kubernetes API server is always accessible.

## Introduction
Kubernetes is the go-to platform for container orchestration, but setting up a highly available (HA) Kubernetes cluster can be challenging. In this guide, we will create a Kubernetes cluster with multiple master nodes and redundant load balancers using Keepalived and HAProxy. This setup ensures that even if one of your load balancers fails, your cluster remains functional.

## Why Do You Need a Highly Available Kubernetes Cluster?
A standard Kubernetes cluster typically consists of a single master node that manages multiple worker nodes. The master node handles critical tasks like scheduling pods, maintaining the cluster state, and managing the API server. If this master node fails, the entire cluster can go down, leading to application downtime—a situation no business can afford.

To mitigate this risk, we set up a highly available Kubernetes cluster. In an HA setup, multiple master nodes share the load, ensuring that even if one or more master nodes fail, the cluster remains operational. This redundancy is achieved through a concept known as quorum, which we'll discuss in detail later.

## Understanding Quorum in HA Clusters
The concept of quorum is vital in HA clusters. Quorum refers to the minimum number of master nodes required to make decisions in the cluster. If the number of active master nodes falls below this threshold, the cluster can no longer function correctly.

#### Calculating Quorum
To calculate the quorum, you can use the following formula:
```bash
Quorum = floor(n/2) + 1
```
Where n is the total number of master nodes. Let's look at a couple of examples to understand this better:

#### 3 Master Nodes Cluster:
- Quorum = floor(3/2) + 1 = 1 + 1 = 2
- If one master node fails, the remaining two nodes can still make decisions, keeping the cluster operational.
#### 5 Master Nodes Cluster:
- Quorum = floor(5/2) + 1 = 2 + 1 = 3
- Even if two master nodes fail, the cluster remains functional as long as the remaining three nodes are active.

In essence, the quorum ensures that the cluster can continue to operate correctly even in the event of node failures.

## Prerequisites
Before we begin, ensure you have the following:

- AWS account
- Basic knowledge of Kubernetes and its components.

## Overview of the Setup
We will set up a Kubernetes cluster with the following components:

<span style="color: Yellow;"> __Three Master Nodes__</span>: To ensure redundancy in the control plane.

<span style="color: Yellow;"> __Two Load Balancers__</span>: Implemented using HAProxy to distribute traffic to the master nodes.

<span style="color: Yellow;"> __Keepalived__</span>: To manage a virtual IP address that floats between the two load balancers, ensuring high availability.

## __Hardware Requirements__
For this demo, each virtual machine will be configured as follows:

__Masters and Workers__: 2 CPUs, 4 GB RAM (```t2.medium```)

__Load Balancers__: 1 CPU, 1 GB RAM (```t2.micro```)

All virtual machines will run on Ubuntu 24.04 LTS with Kubernetes version 1.30.0.

### Setting Up the HA Kubernetes Cluster

#### Prerequisites: 
Before you begin, ensure you have the following virtual machines (VMs) set up:

+ ```Two``` VM for HAProxy Load Balancer: HAProxy will distribute the load among the master nodes.
+ ```Three``` VMs for Master Nodes: These nodes will manage the worker nodes.
+ ```Two``` VMs for Worker Nodes: These nodes will run the application workloads.

1. Setting Up the Virtual Machines

First, we'll create the necessary virtual machines using terraform. Below is a sample terraform configuration:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *"07.Real-Time-DevOps-Project(Fully_HA-Terraform-III)/k8s-terraform-setup"* and run the terraform command.
```bash
cd k8s-terraform-setup/
$ ls -l
total 20
drwxr-xr-x 1 bsingh 1049089    0 Aug 11 11:43 HA_proxy_LB/
drwxr-xr-x 1 bsingh 1049089    0 Aug 11 11:46 Master_Worker_Setup/
-rw-r--r-- 1 bsingh 1049089  562 Aug 11 11:39 main.tf
```

You need to run ```main.tf``` file using following terraform command note-- make sure you will run main.tf not from inside the folders (HA_proxy_LB,Master_Worker_Setup)

```bash
cd \07.Real-Time-DevOps-Project(Fully_HA-Terraform-III)\k8s-terraform-setup


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          11/08/24  11:43 AM                HA_proxy_LB
da---l          11/08/24  11:46 AM                Master_Worker_Setup
-a---l          09/08/24   4:03 PM            482 .gitignore
-a---l          11/08/24  11:39 AM            562 main.tf

# Now, run the following command.
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```
-------
# Lab Setup:

## Configuring the Load Balancer
- <span style="color: Yellow;"> Install HAProxy on your load balancer VM </sapn>
- <span style="color: Yellow;"> Set up a Highly Available Kubernetes Cluster using kubeadm<span>
Follow this documentation to set up a highly available Kubernetes cluster using __Ubuntu 24.04 LTS LTS__ with keepalived and haproxy

This documentation guides you in setting up a cluster with three master nodes, one worker node and two load balancer node using HAProxy and Keepalived.

### __Environment Setup__
|HostName|
|----|
|HA-proxy01|
|HA-proxy02|
|K8-Master01|
|K8-Master02|
|K8-Master01|
|K8-Worker01|
|K8-Worker02|

> * Password for the **root** account on all these virtual machines is **xxxxxxx**
> * Perform all the commands as root user unless otherwise specified


### <span style="color: cyan;"> Virtual IP managed by Keepalived on the load balancer nodes
|<span style="color: Yellow;"> Virtual IP</span>|
|----|
|<span style="color: Yellow;">172.31.80.50 <span>|

### <span style="color: Yellow;"> Set hostname on all EC2 instances</span>
> Including (loadbalancer1-2 & master01-03 and Worker01-02)

- Change the hostname:
```bash
sudo hostnamectl set-hostname HA-proxy01
sudo hostnamectl set-hostname HA-proxy02
sudo hostnamectl set-hostname K8-Master01
sudo hostnamectl set-hostname K8-Master02
sudo hostnamectl set-hostname K8-Master03
sudo hostnamectl set-hostname K8-Worker01
sudo hostnamectl set-hostname K8-Worker02
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

## <span style="color: red;"> Set up load balancer nodes (loadbalancer1 & loadbalancer2)</span>

<!-- #### Install Keepalived & Haproxy
```bash
sudo -i
apt-get install -y curl
apt-get update && apt-get install -y keepalived haproxy
``` -->
### Verify the ```Keepalived and Haproxy``` service status
```bash
systemctl status keepalived
systemctl status haproxy
```

### Configure keepalived (Create the health check script)
First, check the IP address range of the EC2 instance and identify the subnet from which they are getting their IP addresses. You need to choose an IP address from this range to use as the virtual IP for the HAProxy server in the health check script.

- On both Proxy nodes create the health check script ```/etc/keepalived/check_apiserver.sh```
```bash
sudo -i

sudo tee /etc/keepalived/check_apiserver.sh > /dev/null <<EOF
#!/bin/sh

errorExit() {
  echo "*** \$@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 172.31.80.50; then
  curl --silent --max-time 2 --insecure https://172.31.80.50:6443/ -o /dev/null || errorExit "Error GET https://172.31.80.50:6443/"
fi
EOF
sudo chmod +x /etc/keepalived/check_apiserver.sh

```
Interface name issue: Ensure that the interface name (```eth1``` in your config) exists on your system. You can check available network interfaces with: If not then adjust the config file accordingly.

```bash
ip link show

      or

ip a s
```
##### In my Lab it is as below:
```powershell
ubuntu@ip-172-31-90-55:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 12:98:fb:45:9c:ef brd ff:ff:ff:ff:ff:ff
ubuntu@ip-172-31-90-55:~$ ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 12:98:fb:45:9c:ef brd ff:ff:ff:ff:ff:ff
    inet 172.31.90.55/20 brd 172.31.95.255 scope global dynamic eth0
       valid_lft 3429sec preferred_lft 3429sec
    inet6 fe80::1098:fbff:fe45:9cef/64 scope link
       valid_lft forever preferred_lft forever
```

* Adjust the connect name ```interface eth1```

Create keepalived config /etc/keepalived/keepalived.conf
```bash
sudo tee /etc/keepalived/keepalived.conf > /dev/null <<EOF
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  timeout 10
  fall 5
  rise 2
  weight -2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 1
    priority 100
    advert_int 5
    authentication {
        auth_type PASS
        auth_pass mysecret
    }
    virtual_ipaddress {
        172.31.80.50
    }
    track_script {
        check_apiserver
    }
}
EOF
```
### Enable & start keepalived service
```bash
sudo systemctl restart keepalived
sudo systemctl enable --now keepalived
sudo systemctl restart haproxy
sudo systemctl enable haproxy
```




### To verify which one is master HA Proxy

- Check HAProxy:
Ensure HAProxy is listening on port 6443:
```bash
sudo netstat -tuln | grep 6443
```

- Check Keepalived:
The virtual IP should be assigned to the MASTER node:
```bash
journalctl -flu keepalived
                or
sudo systemctl status keepalived
                or 
ip a | grep <virtual_ip>
                or
sudo grep Keepalived /var/log/syslog
                or
sudo ip addr show | grep 172.31.80.50  # Replace with your virtual IP
                or
ip a | grep 172.31.80.50
```

- Failover Test:
Stop the Keepalived service on the MASTER node and check if the virtual IP is moved to the BACKUP node:
```bash
sudo systemctl stop keepalived
ip a | grep 172.31.80.50  # On Backup (Load Balancer02) Node
```

> In my case my ```HA-proxy02``` become master.


### Configure haproxy
On both load balancer nodes, configure HAProxy to forward traffic to the master nodes:
Edit the HAProxy configuration file ```/etc/haproxy/haproxy.cfg```
```
cat >> /etc/haproxy/haproxy.cfg <<EOF

frontend kubernetes-frontend
  bind *:6443
  mode tcp
  option tcplog
  default_backend kubernetes-backend

backend kubernetes-backend
  option httpchk GET /healthz
  http-check expect status 200
  mode tcp
  option ssl-hello-chk
  balance roundrobin
    server master1 3.84.181.226:6443 check fall 3 rise 2
    server master2 34.228.82.252:6443 check fall 3 rise 2
    server master3 3.90.205.74:6443 check fall 3 rise 2
EOF
```
##### Restart HAProxy to apply the configuration: (Enable & restart haproxy service)
```
systemctl enable haproxy && systemctl restart haproxy
```

## <span style="color: red;"> Pre-requisites </span> on all kubernetes nodes (masters & workers)

<!-- ##### Disable swap (after reboot it would ramain disable state)
```bash
sudo -i
swapoff -a; sed -i '/swap/d' /etc/fstab
``` -->
##### We will disable Firewall if it is enabled.
```bash
systemctl disable --now ufw
```
<!-- ##### Enable and Load Kernel modules
```bash
cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
``` -->


<!-- ##### Add Kernel settings (If server rebooted then file would be auto added after reboot)
```bash
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
``` -->
<!-- ##### Install containerd runtime
```bash
{
  apt update
  apt install -y containerd apt-transport-https
  mkdir /etc/containerd
  containerd config default > /etc/containerd/config.toml
  systemctl restart containerd
  systemctl enable containerd
}
```
#### Verify the containerd status and service
```bash
systemctl status containerd
containerd --version
journalctl -u containerd
``` -->

<!-- ##### Add apt repo for kubernetes & Install Kubernetes components

create a ```install_kube.sh``` file and paste the following content
```bash
cat >> install_kube.sh <<EOF
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo apt-get update
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubeadm=1.30.0-1.1 kubelet=1.30.0-1.1 kubectl=1.30.0-1.1
EOF
chmod +x install_kube.sh
```
run it 
```bash
./install_kube.sh
``` -->

## <span style="color: red;"> Setup Bootstrap the cluster</span>

Now, SSH into one of the master nodes and initialize the Kubernetes cluster: On ```Master01``` [*You can choose any master node*]

- Check Kubelet Status

Run the following command to check the status of the kubelet service:
```bash
sudo systemctl status kubelet
```
### <span style="color: Yellow;"> Initializing the Kubernetes Cluster </span>

- Replace LoadBalancerIP with the IP address of your HAProxy load balancer.

```bash
sudo -i
kubeadm init --control-plane-endpoint="172.31.1.50:6443" --upload-certs --apiserver-advertise-address=172.31.19.179 --pod-network-cidr=10.244.0.0/16
# as we are selecting master01 node then we will use IP address 172.31.19.179
```
To Inspect Control Plane Containers
```bash
 sudo crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock ps -a | grep kube | grep -v pause
 ```
To inspect the logs of a failing container, replace CONTAINERID with the actual container ID:

Follow the output instructions to join the other master and worker nodes to the cluster.
```bash
sudo crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock logs CONTAINERID
```
If you get an error then run the following command
Try Re-running Kubeadm
```bash
sudo kubeadm reset -f
sudo kubeadm init --control-plane-endpoint="172.31.80.50:6443" --upload-certs --apiserver-advertise-address=172.31.29.29 --pod-network-cidr=10.244.0.0/16
```

```css
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 192.168.1.50:6443 --token gmzu3t.vsmajpb4cr16y6nx \
        --discovery-token-ca-cert-hash sha256:25d88d828dbf73e1be74f7dea1e0653290706ceaf46583fd6066186436367bb3 \
        --control-plane --certificate-key 83f8c428529481af7aaa7e54a6fe9f36e8efe5a7992ecd9422219db79ca287a1

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.50:6443 --token gmzu3t.vsmajpb4cr16y6nx \
        --discovery-token-ca-cert-hash sha256:25d88d828dbf73e1be74f7dea1e0653290706ceaf46583fd6066186436367bb3
```
#### On ```master01``` will run the following command.
```bash
 mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### On ```Master01``` Deploy Calico network [you can choose any master, for my Lab, I am using ```Master01```]
```bash
sudo -i
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml
# wget https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml
# kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f calico.yaml

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Official Page - https://docs.tigera.io/calico/3.27/about/
```
 <span style="color: cyan;">__Note__--> I was getting an error message while using ```v3.18```manifests for ```calico.yaml``` file and noticed that "The error message indicates that the ```PodDisruptionBudget``` resource in the calico.yaml manifest is using an outdated API version ```(policy/v1beta1)```. Kubernetes 1.21 and later versions have deprecated this version in favor of ```policy/v1```."

## <span style="color: Yellow;"> Join other ```Master 02 & Master03``` nodes to the cluster
> Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

```bash
 kubeadm join 192.168.1.50:6443 --token gmzu3t.vsmajpb4cr16y6nx \
        --discovery-token-ca-cert-hash sha256:25d88d828dbf73e1be74f7dea1e0653290706ceaf46583fd6066186436367bb3 \
        --control-plane --certificate-key 83f8c428529481af7aaa7e54a6fe9f36e8efe5a7992ecd9422219db79ca287a1
```

Now, check it.
```bash
kubectl get pods -n kube-system
kubectl get nodes -o wide
```

> IMPORTANT: Don't forget the --apiserver-advertise-address option to the join command when you join the other master nodes, if you are using additional NIC then it need to use.

## <span style="color: Yellow;"> Join worker nodes to the cluster</span>.
> Use the kubeadm join command you copied from the output of kubeadm init command on the first master
```bash
kubeadm join 192.168.1.50:6443 --token gmzu3t.vsmajpb4cr16y6nx \
        --discovery-token-ca-cert-hash sha256:25d88d828dbf73e1be74f7dea1e0653290706ceaf46583fd6066186436367bb3
````

Now, check it.
```bash
kubectl get pods -n kube-system
kubectl get nodes -o wide
```

## <span style="color: Yellow;">Verifying the cluster</span>
```
kubectl cluster-info
kubectl get nodes
```
```bash
root@master01:~# kubectl cluster-info
Kubernetes control plane is running at https://192.168.1.50:6443
CoreDNS is running at https://192.168.1.50:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
root@master01:~#
```
**Check the status of all pods:**
  ```bash
  kubectl get pods --all-namespaces
  ```

By following these instructions, you will have created a highly available Kubernetes cluster with two master nodes, three worker nodes, and a load balancer that distributes traffic across the master nodes. This setting assures that if one master node dies, the other will still process API calls.

## <span style="color: Yellow;">Verification (following command should be run on all master nodes ```M1, M2 & M3```)

### Install etcdctl to verify the health check
**Install etcdctl using apt:**
  ```bash
   sudo apt-get update
   sudo apt-get install -y etcd-client
  ```

### Verify Etcd Cluster Health, It needs to run on all master nodes. 
**Check the health of the etcd cluster:**
```bash
sudo ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint health
```


**Check the cluster membership:**
```bash
sudo ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key member list
```
### <span style="color: Yellow;">Verify ```HAProxy``` Configuration and Functionality

**Configure HAProxy Stats:**
   - Add the stats configuration to `/etc/haproxy/haproxy.cfg`:
     ```haproxy
     listen stats
         bind *:8404
         mode http
         stats enable
         stats uri /
         stats refresh 10s
         stats admin if LOCALHOST
     ```


**Restart HAProxy:**
```bash
sudo systemctl restart haproxy
```
**Check HAProxy Stats:**
- Access the stats page at `http://<LOAD_BALANCER_IP>:8404`.
```sh
http://3.91.39.241:8404/
```


### Will do the deployment to check the functionality.

[Will use this yml file](https://github.com/mrbalraj007/Boardgame/blob/main/deployment-service.yaml)

will go to master 3
 will create a deploy.yml and paste the following conent
```powershell
apiVersion: apps/v1
kind: Deployment # Kubernetes resource kind we are creating
metadata:
  name: boardgame-deployment
spec:
  selector:
    matchLabels:
      app: boardgame
  replicas: 2 # Number of replicas that will be created for this deployment
  template:
    metadata:
      labels:
        app: boardgame
    spec:
      containers:
        - name: boardgame
          image: adijaiswal/boardgame:latest # Image that will be used to containers in the cluster
          imagePullPolicy: Always
          ports:
            - containerPort: 8080 # The port that the container is running on in the cluster
---
apiVersion: v1 # Kubernetes API version
kind: Service # Kubernetes resource kind we are creating
metadata: # Metadata of the resource kind we are creating
  name: boardgame-ssvc
spec:
  selector:
    app: boardgame
  ports:
    - protocol: "TCP"
      port: 8080 # The port that the service is running on in the cluster
      targetPort: 8080 # The port exposed by the service
  type: LoadBalancer # type of the service.

```
- will deploy the file from master 3.
```sh
kubectl apply -f deploy.yml
```
- View from Master 1
```sh
 kubectl get all
NAME                                        READY   STATUS    RESTARTS   AGE
pod/boardgame-deployment-6bfc85f56d-82n2z   1/1     Running   0          3m20s
pod/boardgame-deployment-6bfc85f56d-stswz   1/1     Running   0          3m5s

NAME                     TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
service/boardgame-ssvc   LoadBalancer   10.98.2.227   <pending>     8080:32499/TCP   5m38s
service/kubernetes       ClusterIP      10.96.0.1     <none>        443/TCP          36m

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/boardgame-deployment   2/2     2            2           5m38s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/boardgame-deployment-6bfc85f56d   2         2         2       3m20s
replicaset.apps/boardgame-deployment-7d7f76876f   0         0         0       5m38s

# describe the pod if needed.
ubuntu@ip-172-31-29-116:~$ kubectl describe pod boardgame-deployment-6bfc85f56d-82n2z
Name:             boardgame-deployment-6bfc85f56d-82n2z
Namespace:        default
Priority:         0
Service Account:  default
Node:             ip-172-31-18-179/172.31.18.179
Start Time:       Fri, 09 Aug 2024 07:39:55 +0000
Labels:           app=boardgame
                  pod-template-hash=6bfc85f56d
Annotations:      cni.projectcalico.org/containerID: 4980888e7b1752260904286e0611e7a9f01f79d59d03ef76e57380032f9d626d
                  cni.projectcalico.org/podIP: 10.244.224.2/32
                  cni.projectcalico.org/podIPs: 10.244.224.2/32
Status:           Running
IP:               10.244.224.2
IPs:
  IP:           10.244.224.2
Controlled By:  ReplicaSet/boardgame-deployment-6bfc85f56d
Containers:
  boardgame:
    Container ID:   containerd://adb82acb13786599710397ad328e021c7c447d656f91ad30334d58b3eb98a8dc
    Image:          adijaiswal/boardgame:latest
    Image ID:       docker.io/adijaiswal/boardgame@sha256:1fc859b0529657a73f8078a4590a21a2087310372d7e518e0adff67d55120f3d
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 09 Aug 2024 07:40:09 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-9hp5f (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-9hp5f:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  5m24s  default-scheduler  Successfully assigned default/boardgame-deployment-6bfc85f56d-82n2z to ip-172-31-18-179
  Normal  Pulling    5m24s  kubelet            Pulling image "adijaiswal/boardgame:latest"
  Normal  Pulled     5m11s  kubelet            Successfully pulled image "adijaiswal/boardgame:latest" in 12.748s (12.748s including waiting). Image size: 282836720 bytes.
  Normal  Created    5m10s  kubelet            Created container boardgame
  Normal  Started    5m10s  kubelet            Started container boardgame
ubuntu@ip-172-31-29-116:~$
```
since 172.31.18.179 is a worker 2 and will note it down the public IP address and will try to open it on broswer.
```sh
http://3.80.108.177:32499/
```
### Test High Availability
**Simulate Master Node Failure:**
We will run the command on master 02 to double verify.

   - Stop the kubelet service and Docker containers on one of the master nodes to simulate a failure:
     ```bash
     sudo systemctl stop kubelet
     sudo docker stop $(sudo docker ps -q)
     ```
![alt text](image-13.png)

**Verify Cluster Functionality:**
   - Check the status of the cluster from a worker node or the remaining master node:
     ```bash
     kubectl get nodes
     kubectl get pods --all-namespaces
     ```
   - The cluster should still show the remaining nodes as Ready, and the Kubernetes API should be accessible.

![alt text](image-12.png)

**HAProxy Routing:**
   - Ensure that HAProxy is routing traffic to the remaining master node. Check the stats page or use curl to test:
     ```bash
     curl -k https://<LOAD_BALANCER_IP>:6443/version
     ```
```sh
ubuntu@ip-172-31-27-21:~$ curl -k https://3.91.39.241:6443/version
{
  "major": "1",
  "minor": "30",
  "gitVersion": "v1.30.3",
  "gitCommit": "6fc0a69044f1ac4c13841ec4391224a2df241460",
  "gitTreeState": "clean",
  "buildDate": "2024-07-16T23:48:12Z",
  "goVersion": "go1.22.5",
  "compiler": "gc",
  "platform": "linux/amd64"
}ubuntu@ip-172-31-27-21:~$
```

























## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
scp root@192.168.1.101:/etc/kubernetes/admin.conf ~/.kube/config
```
Password for root account is "xxxxxxxxx"
#### Now, we will shutdown one master node and see the status.
I have choosed ```Master03``` and after shutdown the master03 below is the status.


Now, we will power on the master03 again and will shutdown the proxy to test.


For proxy verification, Currently HAproxy02 is holding the master role


Will shutdown the ```HAproxy02``` and test it out.

After HAProxy02 is power-off now, HAproxy01 has taken all the loads and no impact on the K8s Cluster.

PowerState of ```HAPRoxy02```


## <span style="color: Yellow;">Verifying the cluster</span>
```
kubectl cluster-info
kubectl get nodes
```

If we stop the HAproxy services from HAProxy nodes, then we will lose the K8s connetivity for some time because we have given in check_apiserver that it will check for ```fall5```
```bash
 interval 3
  timeout 10
  fall 5
  rise 2
  weight -2
```
For testing purposes, we will power on ```HAProxy02```, and stop the services "haproxy" from ```HAproxy01``` on it, and see.

## <span style="color: Yellow;">To destroy the setup using Terraform.</span>

First go to ```"Master_Worker_Setup"``` directory then run the command
```bash
terraform destroy --auto-approve
```
Once it's done then go to "HA_proxy_LB" directory
```bash
terraform destroy --auto-approve
```


## Conclusion
By following this guide, you've successfully set up a highly available Kubernetes cluster with redundant load balancers using Keepalived and HAProxy. This setup ensures that your Kubernetes API server remains accessible even if one of your load balancers goes down, providing greater resilience and reliability for your applications.

This approach can be further extended by adding more master nodes, worker nodes, and load balancers to meet your specific requirements.


### <span style="color: Red;"> Troubleshooting:

If you want to delete and recreate specific section then use below command

- Destroy the current k8s_master EC2 instances:

Run the following command to destroy the existing k8s_master instances:
```bash
terraform destroy -target="aws_instance.k8s_master" --auto-approve
```

- Recreate the k8s_master EC2 instances:

After destroying the k8s_master instances, you can recreate them by running:
```bash
terraform apply -target="aws_instance.k8s_master" --auto-approve
```