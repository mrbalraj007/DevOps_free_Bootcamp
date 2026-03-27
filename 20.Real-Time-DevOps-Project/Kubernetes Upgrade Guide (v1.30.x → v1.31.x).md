root@K8SClusterNW1:/home/dc-ops# cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy


# Sequential Kubernetes Upgrade Guide (v1.30 → v1.35) 

## Overview 

- This guide covers sequential upgrades: 1.30→1.31→1.32→1.33→1.34→1.35. 

- Kubernetes does not support skipping minor versions. 

- Each upgrade requires updating kubeadm, applying control‑plane upgrade, then updating worker nodes. 

### Universal Repo Setup (Before Each Version Step) 

- Remove old repos and add version-specific pkgs.k8s.io repo. 

- Run apt update and verify package versions. 

Control Plane Upgrade Steps 

- Upgrade kubeadm on master. 

- Run kubeadm upgrade plan. 

- Drain master. 

- Apply kubeadm upgrade apply v1.xx.yy. 

- Upgrade kubelet + kubectl. 

- Uncordon master. 

Worker Node Upgrade Steps 

- Drain worker node. 

- Upgrade kubeadm. 

- Run kubeadm upgrade node. 

- Upgrade kubelet + kubectl. 

- Uncordon worker. 

#### Version Jump Details 

- *1.30→1.31 uses repo stable:/v1.31*. 

- *1.31→1.32 uses repo stable:/v1.32*. 

- *1.32→1.33 uses repo stable:/v1.33*. 

- *1.33→1.34 uses repo stable:/v1.34*. 

- *1.34→1.35 uses repo stable:/v1.35*. 


# Kubernetes Upgrade Guide (v1.30.x → v1.31.x) 

Overview 

- This guide describes how to upgrade a Kubernetes cluster created using kubeadm from v1.30.x to v1.31.x. 

- Upgrades must follow the official rule: Skipping minor versions is unsupported. You must upgrade one minor version at a time. 

<span style="color: Yellow;"> Part 1 — Pre‑Upgrade Requirements</span> 

- Confirm cluster health using kubectl get nodes and kubectl get pods -A. 

- Back up etcd, application databases, and manifests before upgrading. 

Part 2 — Configure Kubernetes v1.31 Repository (ALL NODES) 

- Remove old Kubernetes APT repo files. 

- Add the new pkgs.k8s.io Kubernetes repository. 

- Add repository GPG key. 

- Run apt update and verify package availability. 

Part 3 — Upgrade Control Plane Node (Master) 

- Upgrade kubeadm to v1.31.14-1.1. 

- Run kubeadm upgrade plan. 

- Drain the master node. 

- Execute kubeadm upgrade apply v1.31.14. 

- Upgrade kubelet and kubectl. 

- Uncordon the master node. 

Part 4 — Upgrade Worker Nodes (One at a Time) 

- Drain the worker node. 

- Upgrade kubeadm. 

- Run kubeadm upgrade node. 

- Upgrade kubelet and kubectl. 

- Uncordon the worker node. 

Part 5 — Verification 

- Run kubectl get nodes to confirm all nodes are at v1.31.14. 

- Verify system pods with kubectl get pods -A -o wide. 

# ✅ Overview
This guide describes how to upgrade a Kubernetes cluster created using kubeadm from:
`v1.30.14 → v1.31.14`

## Upgrades must follow the official rule:

- Skipping MINOR versions when upgrading is unsupported. You must upgrade only one minor version at a time.
 
- The documented approach requires:

   - Upgrade control plane first
   - Then upgrade worker nodes one by one
   - Drain nodes before worker upgrade as recommended


### ✅ Part 1 — Pre‑Upgrade Requirements
#### 1️⃣ Confirm cluster health
- <span style="color: Yellow;"> Run on master:</span>
```Shell
kubectl get nodeskubectl get pods -A
```

All nodes must be Ready and pods must be Running.

- <span style="color: Yellow;"> 2️⃣ Backup cluster components</span>
- Take snapshots of:

  - etcd (optional but recommended)
  - Application databases
  - Manifests and configuration


### ✅ Part 2 — Configure Kubernetes v1.31 Repository (ALL NODES)
- Perform this on master and each worker node.
#### 1️⃣ Remove old repo (if exists)
```Shell
sudo rm /etc/apt/sources.list.d/kubernetes.list 2>/dev/null || true
sudo rm /etc/apt/trusted.gpg.d/kubernetes.gpg 2>/dev/null || true
```

#### 2️⃣ Add new official Kubernetes v1.31 repo
(This is the new repo system replacing apt.kubernetes.io)
```Shell
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /EOF
```
#### 3️⃣ Add GPG key
```Shell
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key \    | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg
```

#### 4️⃣ Update apt
```Shell
sudo apt update
```

#### To confirm:
```Shell
apt-cache madison kubeadm
```

You should see versions like:
*kubeadm | 1.31.14-1.1 | https://pkgs.k8s.io/core:/stable:/v1.31/deb*


### ✅ Part 3 — Upgrade CONTROL PLANE NODE (MASTER)
#### 1️⃣ Upgrade kubeadm on master
```Shell
sudo apt-mark unhold kubeadm
sudo apt install -y kubeadm=1.31.14-1.1
kubeadm version
```
Expected result:
`kubeadm version: v1.31.14`


#### 2️⃣ Review upgrade plan
```Shell
sudo kubeadm upgrade plan
```
This uses kubeadm’s built‑in minor version upgrade checks.
 

#### 3️⃣ Drain master node
```Shell
kubectl drain master --ignore-daemonsets --delete-emptydir-data
```

#### 4️⃣ Apply control-plane upgrade
```Shell
sudo kubeadm upgrade apply v1.31.14
```
#### ✅ This updates:
`API Server, Controller Manager, Scheduler, kube-proxy, CoreDNS, etcd
(as listed in plan output)
`
#### 5️⃣ Upgrade kubelet + kubectl on master
- Unhold first:
```Shell
sudo apt-mark unhold kubelet kubectl
```

#### Upgrade:
```Shell
sudo apt install kubelet=1.31.14-1.1 kubectl=1.31.14-1.1
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

#### 6️⃣ Uncordon master
```Shell
kubectl uncordon master
```
✅ Control plane upgrade is complete.

### ✅ Part 4 — Upgrade WORKER NODES (One at a Time)
Repeat these steps for:

`k8sclusternw1`
`k8sclusternw2`
`k8sclusternw3`

#### 🔷 Step A — Drain the worker node (run on master)
```Shell
kubectl drain <worker-node> --ignore-daemonsets --delete-emptydir-data
```

- Draining is mandatory before kubelet upgrades.
 
#### 🔷 Step B — Upgrade kubeadm on the worker
SSH into the worker:
```Shell
sudo apt-mark unhold kubeadm
sudo apt install -y kubeadm=1.31.14-1.1
kubeadm version
```

#### 🔷 Step C — Apply the node upgrade
```Shell
sudo kubeadm upgrade node
```

This updates the worker’s kubelet config to match the upgraded control plane.

#### 🔷 Step D — Upgrade kubelet + kubectl on the worker
First unhold:
```Shell
sudo apt-mark unhold kubelet kubectl
```
Then install:
```Shell
sudo apt install kubelet=1.31.14-1.1 kubectl=1.31.14-1.1
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

#### 🔷 Step E — Uncordon the worker (on master)
```Shell
kubectl uncordon <worker-node>
```

### ✅ Part 5 — Cluster Verification
After all nodes upgraded:
##### 1️⃣ Check node versions
```Shell
kubectl get nodes
```
Expected result:
```sh
master           Ready   control-plane   v1.31.14
k8sclusternw1    Ready   <none>          v1.31.14
k8sclusternw2    Ready   <none>          v1.31.14
k8sclusternw3    Ready   <none>          v1.31.14
```
##### 2️⃣ Check system pods
Shellkubectl get pods -A -o wideShow more lines
All pods should be Running.

#### ✅ Part 6 — Notes & Best Practices
✔️ Kubernetes official policy forbids skipping minor versions.
✔️ Upgrade control plane before worker nodes.
✔️ Always drain nodes before kubelet upgrade.
✔️ Ensure the correct repo is used (pkgs.k8s.io).
✔️ Upgrade kubeadm → apply upgrade → upgrade kubelet/kubectl.