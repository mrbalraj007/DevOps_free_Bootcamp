# multi-version sequential upgrade KB (1.30 → 1.35) 
## kubeadm-based cluster upgrade — Zero Downtime (Rolling Strategy)

### ✅ 1. Overview
This KB provides a complete procedure for upgrading a Kubernetes cluster created with kubeadm from:
`v1.30.x → v1.31.x → v1.32.x → v1.33.x → v1.34.x → v1.35.x`

**Important Kubernetes upgrade rules:**

- **Skipping minor versions is NOT supported. Upgrades must occur one minor version at a time**.
 
- *Control plane must be upgraded before worker nodes*.

- *Nodes running kubelet must be drained before a kubelet minor upgrade*.

- *kubeadm may be 1 minor version ahead of the cluster, but kubelet must not*.


### ✅ 2. Universal Pre‑Upgrade Steps (Performed Once)
<span style="color: Yellow;"> Perform on all nodes (master + workers).</span>
- <span style="color: cyan;">2.1 Remove old Kubernetes APT repo</span>
```Shell
sudo rm /etc/apt/sources.list.d/kubernetes.list 2>/dev/null || true
sudo rm /etc/apt/trusted.gpg.d/kubernetes.gpg 2>/dev/null || true
```
- <span style="color: cyan;">2.2 Add correct repository for each target version before upgrading</span>
For each version step, use this structure:
```Shell
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://pkgs.k8s.io/core:/stable:/v1.xx/deb/ /
EOF

sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.xx/deb/Release.key \  | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg

sudo apt update
```
Replace xx with the version you are upgrading to.

- <span style="color: cyan;">✅ 3. Upgrade Process (Performed for EACH minor version)</span>

Below is the repeatable pattern to move from 1.30 → 1.31, then 1.31 → 1.32, etc.

### ✅ STEP GROUP A — CONTROL PLANE UPGRADE
Repeat these steps for each version jump (e.g., 1.31, 1.32 … 1.35).
- <span style="color: cyan;">A1 — Upgrade kubeadm on master</span>
```Shell
sudo apt-mark unhold kubeadm
sudo apt install -y kubeadm=1.xx.yy-1.1
kubeadm version
```

- <span style="color: cyan;">A2 — Review upgrade plan</span>
```Shell
sudo kubeadm upgrade plan
```
This retrieves upgrade info from cluster & upstream. [scaleops.com]
- <span style="color: cyan;">A3 — Drain master</span>
```Shell
kubectl drain master --ignore-daemonsets --delete-emptydir-data
```
- <span style="color: cyan;">A4 — Apply the upgrade</span>
```Shell
sudo kubeadm upgrade apply v1.xx.yy
```

- <span style="color: cyan;">A5 — Upgrade kubelet + kubectl on master</span>
```Shell
sudo apt-mark unhold kubelet kubectl
sudo apt install -y kubelet=1.xx.yy-1.1 kubectl=1.xx.yy-1.1
sudo systemctl daemon-reload
sudo systemctl restart
```

- <span style="color: cyan;">A6 — Uncordon master
```Shell
kubectl uncordon master
```
✅ Your control plane is now upgraded to the new minor version.


### ✅ STEP GROUP B — WORKER NODE UPGRADE
- Perform each worker one at a time.
- <span style="color: cyan;">B1 — Drain worker (on master)/span<>
```Shell
kubectl drain <worker> --ignore-daemonsets --delete-empty
```

- <span style="color: cyan;">B2 — Upgrade kubeadm (on worker)</span>
```Shell
sudo apt-mark unhold kubeadm
sudo apt install -y kubeadm=1.xx.yy-1.1
sudo kubeadm
```

- <span style="color: cyan;">B3 — Upgrade kubelet + kubectl (on worker)</span>
```Shell
sudo apt-mark unhold kubelet kubectl
sudo apt install -y kubelet=1.xx.yy-1.1 kubectl=1.xx.yy-1.1
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

- <span style="color: cyan;">B4 — Uncordon worker (on master)</span>
```Shell
kubectl uncordon <worker>
```
✅ Worker node is now upgraded.

### ✅ 4. Version-by-Version Commands (Copy/Paste Ready)
Below are the exact values to substitute into the above pattern.

#### ✅ 4.1 Upgrade v1.30.x → v1.31.14
Repository version:
`v1.31`

Package versions:
```shell
kubeadm = 1.31.14-1.1
kubelet = 1.31.14-1.1
kubectl = 1.31.14-1.1
```

Upgrade commands follow Step `Groups A` and `B`.

#### ✅ 4.2 Upgrade v1.31.x → v1.32.x
Repository version:
`v1.32`

Package versions:
```shell
kubeadm = 1.32.xx-1.1
kubelet = 1.32.xx-1.1
kubectl = 1.32.xx-1.1
```
Same procedure as before.

#### ✅ 4.3 Upgrade v1.32.x → v1.33.x
Repository:
`v1.33`

Packages example:
```shell
kubeadm = 1.33.yy-1.1
kubelet = 1.33.yy-1.1
kubectl = 1.33.yy-1.1
```


#### ✅ 4.4 Upgrade v1.33.x → v1.34.x
Repository:
`v1.34
`
Packages example:
```shell
kubeadm = 1.34.zz-1.1
kubelet = 1.34.zz-1.1
kubectl = 1.34.zz-1.1
```

#### ✅ 4.5 Upgrade v1.34.x → v1.35.x
Repository:
**v1.35**

Packages example:
```shell
kubeadm = 1.35.mm-1.1
kubelet = 1.35.mm-1.1
kubectl = 1.35.mm-1.1
```

#### ✅ 5. Final Verification After Reaching v1.35
```Shell
kubectl get nodeskubectl get pods -A -o wide
```

All nodes should report:
**v1.35.x
**
Everything should be Ready.
