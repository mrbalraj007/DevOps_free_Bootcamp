#!/bin/bash
# This script retrieves the URLs and credentials for ArgoCD, Prometheus, and Grafana

# Configure AWS and update kubeconfig for the EKS cluster
#aws configure
aws eks update-kubeconfig --region "us-east-1" --name "balraj-cluster"  # replace with your cluster name

# ArgoCD Access
argo_url=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | head -n 1)

# Retrieve ArgoCD admin password from Kubernetes secret
argo_user="admin"
argo_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

# Prometheus and Grafana URLs and credentials
prometheus_url=$(kubectl get svc -n prometheus | grep stable-kube-prometheus-sta-prometheus | awk '{print $4}')
grafana_url=$(kubectl get svc -n prometheus | grep stable-grafana | awk '{print $4}')
grafana_user="admin"
grafana_password=$(kubectl get secret stable-grafana -n prometheus -o jsonpath="{.data.admin-password}" | base64 --decode)

# Display retrieved information
echo "------------------------"
echo "ArgoCD URL: $argo_url"
echo "ArgoCD User: $argo_user"
echo "ArgoCD Password: $argo_password"
echo
echo "Prometheus URL: $prometheus_url:9090"
echo
echo "Grafana URL: $grafana_url"
echo "Grafana User: $grafana_user"
echo "Grafana Password: $grafana_password"
echo "------------------------"

# Instructions for executing the script
# Save this script as `access.sh`, then run:
# chmod +x access.sh
# ./access.sh
