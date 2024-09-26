provider "aws" {
  region = "us-east-1" # Adjust the region as needed
}

# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Create IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_kind_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Full EC2 permissions to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create an instance profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_kind_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Create a security group to allow SSH access and all traffic
resource "aws_security_group" "instance_sg" {
  name        = "allow_ssh_all"
  description = "Allow SSH and all other traffic"

  #   ingress {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"] # Replace with your IP for better security
  #   }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instance and install Kind, ArgoCD, Helm, Prometheus, and Grafana
resource "aws_instance" "kind_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = "MYLABKEY" # Your existing key pair for SSH access
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Install Docker, Kind, create the Kind cluster, ArgoCD, Helm, Prometheus, and Grafana
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install openjdk-17-jre-headless -y
    sudo apt-get install -y gnupg software-properties-common curl apt-transport-https ca-certificates tree unzip

    # Install Docker
    sudo apt-get install docker.io -y
    sudo chmod 777 /var/run/docker.sock
    sudo chown $USER /var/run/docker.sock
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker

    # Install Kind
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # Create Kind configuration file for 3-node cluster
    cat <<EOF2 > kind-cluster-config.yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
      - role: control-plane
        image: kindest/node:v1.31.0
      - role: worker
        image: kindest/node:v1.31.0
      - role: worker
        image: kindest/node:v1.31.0
    EOF2

    # Create the Kind cluster
    kind create cluster --name kind --config kind-cluster-config.yaml

    # Move kubeconfig to a shared location and set KUBECONFIG env variable
    mkdir -p /home/ubuntu/.kube
    kind get kubeconfig --name kind > /home/ubuntu/.kube/config
    export KUBECONFIG=/home/ubuntu/.kube/config

    # Make sure kubeconfig is accessible
    chown ubuntu:ubuntu /home/ubuntu/.kube/config

    # Install ArgoCD
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    
    # Install Kubernetes dashboard
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

    # Install Helm
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh

    # Add Helm repositories
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add stable https://charts.helm.sh/stable
    helm repo update

    # Install Prometheus and Grafana using Helm
    kubectl create namespace monitoring
    helm install kind-prometheus prometheus-community/kube-prometheus-stack \
      --namespace monitoring \
      --set prometheus.service.nodePort=30000 \
      --set prometheus.service.type=NodePort \
      --set grafana.service.nodePort=31000 \
      --set grafana.service.type=NodePort \
      --set alertmanager.service.nodePort=32000 \
      --set alertmanager.service.type=NodePort \
      --set prometheus-node-exporter.service.nodePort=32001 \
      --set prometheus-node-exporter.service.type=NodePort

  EOF

  tags = {
    Name = "Terraform-Kind-Cluster"
  }

  root_block_device {
    volume_size = 30
  }
}

output "instance_public_ip" {
  value = aws_instance.kind_instance.public_ip
}
