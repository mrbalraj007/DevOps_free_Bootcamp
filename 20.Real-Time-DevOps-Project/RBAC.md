

### Step-by-Step Process

#### 1. Apply ServiceAccount, Role, and RoleBinding YAML Files

Save the following YAML configurations in separate files and apply them.

##### admin-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: admin-role
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin-role
subjects:
  - kind: ServiceAccount
    name: admin
    namespace: default
```

##### general-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: general
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: general-role
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "endpoints", "namespaces"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["apps", "extensions"]
    resources: ["deployments", "replicasets", "daemonsets", "statefulsets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["batch"]
    resources: ["jobs", "cronjobs"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: general-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: general-role
subjects:
  - kind: ServiceAccount
    name: general
    namespace: default
```

##### others-sa.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: others
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: others-role
rules:
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: others-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: others-role
subjects:
  - kind: ServiceAccount
    name: others
    namespace: default
```

Apply these configurations:
```sh
kubectl apply -f admin-sa.yaml
kubectl apply -f general-sa.yaml
kubectl apply -f others-sa.yaml
```

#### 2. Generate Tokens for ServiceAccounts

```sh
# For Admin Service Account
kubectl -n default create token admin

# For General Service Account
kubectl -n default create token general

# For Others Service Account
kubectl -n default create token others
```

#### 3. Create Kubeconfig Files

Use the tokens generated in the previous step to create kubeconfig files for each ServiceAccount.

##### Example: admin-kubeconfig.yaml
Save this content to `admin-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: admin
  name: admin-context
current-context: admin-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: <admin-token>  # Replace with the generated token
```

Replace `<admin-token>` with the actual token generated for the `admin` ServiceAccount.

Repeat this process for the `general` and `others` ServiceAccounts, creating separate kubeconfig files.

##### general-kubeconfig.yaml
Save this content to `general-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDR

NSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: general
  name: general-context
current-context: general-context
kind: Config
preferences: {}
users:
- name: general
  user:
    token: <general-token>  # Replace with the generated token
```

##### others-kubeconfig.yaml
Save this content to `others-kubeconfig.yaml`:
```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJZCt1WDRNSjVsVUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBM01UTXhOakkxTXpkYUZ3MHpOREEzTVRFeE5qTXdNemRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURVU3NOMGxEbWhFUlZFOE92MTBKeFFTeTBydXVOOTJxNkhRMGN6VU5PZTFuckdPNGZKY0FGdmNYSG0KM2FCR0J1V0lQOGtvWUNwUEhnVjd5NjYxR2ZqU0UrUnpYb2tHcTY3ZldFZng1bFJScUVHTjByL0kvcndQY2pPagpoazh5R0RObnRzU2hnbzhsZUVWYk5YNkNhcWltRDFGMGxiejk1YUg3VEhiZ3k4RFU1V1NzRk9PWVlWWmdlSDg2Cm5kK3gveG5VMUdwbkhLbFV0VDlnQldrSTI4b1pFZG4yS21zbHlNMVpjeFF4cGd0NldtV0VGc1lDZHJUeDZTa0oKZ1dseHE3alZUNHNISktKRFo5bXUxQkFLalZneVcxT0Z5SEFRWWZhWURGS093NjFrNjJhNkdHdk96S05sYS90YQpheSt1M2Z2cUYxaFNldGp6NlJZQ0NFMjl1aElWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSYmdWMkdkS01lSnF3YVlQSk1JeVJ5d28raU56QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZtQXlnaXQ3SwpLdGZYRDBzcmxTVS84ODYzMEJXNStWQ0pMSTUwaFUzNTNGM1lJY2FEd3V1NDBGY2RMdUgyM2pHV0ozWnZOYWo2Ck1Qa3ZGWHNxbUZpOXJIME82UTU0K0NCRTZuUmRBelplblo1Nmg1QlFyZmIyNmdUYVVrMWVMM3daV2dGTWRvOEYKeGJFVFhxbXRRSDFpU1ZmakRuN3RXWXdpVVp0VmFwZGY4LzBwWEdnY01jdjZOcy9xRHJ5bjY0d2wrTlk0VENscwpZYXJ1WmQ4blkrM010bGxwQ0VYajJGOEN5V3diaXBRN1p1ZG14cURVZ242aGQ3MTVWWmo1Zml2aXFISnQzdUZxCldBa3B4Y0Q1eUEyNHF0RXpGcUVYUjhmOFRYRzZKZFpvTmtKUGxEODBiQjhjRlVRcTgxWkZPaHhnV3NzNGxoZGQKYnFTelZLU

0tYckFICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://172.31.45.104:6443  # Your K8s API server endpoint
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: others
  name: others-context
current-context: others-context
kind: Config
preferences: {}
users:
- name: others
  user:
    token: <others-token>  # Replace with the generated token
```

#### 4. Use the Kubeconfig Files

Set the `KUBECONFIG` environment variable to point to the desired kubeconfig file.

```sh
export KUBECONFIG=/path/to/admin-kubeconfig.yaml
```

You can now use `kubectl` with the permissions of the `admin` ServiceAccount. Similarly, switch the `KUBECONFIG` environment variable to point to `general-kubeconfig.yaml` or `others-kubeconfig.yaml` to use the respective ServiceAccounts.

#### Example Commands:

```sh
# Use the admin kubeconfig
export KUBECONFIG=/path/to/admin-kubeconfig.yaml
kubectl get pods

# Switch to general kubeconfig
export KUBECONFIG=/path/to/general-kubeconfig.yaml
kubectl get pods

# Switch to others kubeconfig
export KUBECONFIG=/path/to/others-kubeconfig.yaml
kubectl get namespaces
```
