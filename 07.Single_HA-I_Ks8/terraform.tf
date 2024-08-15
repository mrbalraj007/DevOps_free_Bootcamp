# Step 1: Set Up the AWS Infrastructure

# Define the Provider
provider "aws" {
  region = "us-east-1" # Update this with your desired region
}

# Create the VPC

resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "k8s_subnet" {
  count             = 2
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.k8s_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "k8s-subnet-${count.index}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = {
    Name = "k8s-igw"
  }
}

# Create a Route Table and Associate It with the Subnets
resource "aws_route_table" "k8s_route_table" {
  vpc_id = aws_vpc.k8s_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_igw.id
  }
  tags = {
    Name = "k8s-route-table"
  }
}

resource "aws_route_table_association" "k8s_route_table_association" {
  count          = 2
  subnet_id      = element(aws_subnet.k8s_subnet.*.id, count.index)
  route_table_id = aws_route_table.k8s_route_table.id
}

# Security Groups
resource "aws_security_group" "k8s_security_group" {
  name   = "k8s-sg"
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}

# Create EC2 Instances for Master and Worker Nodes
resource "aws_instance" "k8s_master" {
  count           = 3
  ami             = "ami-04a81a99f5ec58529" # Update with your preferred AMI
  instance_type   = "t3.medium"
  subnet_id       = element(aws_subnet.k8s_subnet.*.id, count.index % 2)
  security_groups = [aws_security_group.k8s_security_group.name]

  tags = {
    Name = "k8s-master-${count.index}"
  }

  provisioner "local-exec" {
    command = <<EOT
      # Install Docker, kubeadm, and Kubernetes tools here
      # Update the apt repositories and install necessary packages
      sudo apt-get update && sudo apt-get install -y docker.io kubeadm kubectl
    EOT
  }
}

resource "aws_instance" "k8s_worker" {
  count           = 2
  ami             = "ami-04a81a99f5ec58529" # Update with your preferred AMI
  instance_type   = "t3.medium"
  subnet_id       = element(aws_subnet.k8s_subnet.*.id, count.index % 2)
  security_groups = [aws_security_group.k8s_security_group.name]

  tags = {
    Name = "k8s-worker-${count.index}"
  }

  provisioner "local-exec" {
    command = <<EOT
      # Install Docker, kubeadm, and Kubernetes tools here
      # Update the apt repositories and install necessary packages
      sudo apt-get update && sudo apt-get install -y docker.io kubeadm kubectl
    EOT
  }
}

# Step 2: Initialize the Kubernetes Cluster

#2.1 Initialize the First Master Node
resource "null_resource" "k8s_master_init" {
  provisioner "local-exec" {
    command = <<EOT
      ssh -i MYLABKEY.pem ubuntu@${aws_instance.k8s_master.0.public_ip} "sudo kubeadm init --pod-network-cidr=10.244.0.0/16"
      ssh -i MYLABKEY.pem ubuntu@${aws_instance.k8s_master.0.public_ip} "mkdir -p $HOME/.kube"
      ssh -i MYLABKEY.pem ubuntu@${aws_instance.k8s_master.0.public_ip} "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config"
      ssh -i MYLABKEY.pem ubuntu@${aws_instance.k8s_master.0.public_ip} "sudo chown \$(id -u):\$(id -g) $HOME/.kube/config"
    EOT
  }
}

#  Join Other Masters and Workers to the Cluster
resource "null_resource" "k8s_join_nodes" {
  count = 4

  provisioner "local-exec" {
    command = <<EOT
      ssh -i MYLABKEY.pem ubuntu@${element(concat(aws_instance.k8s_master.*.public_ip, aws_instance.k8s_worker.*.public_ip), count.index)} "sudo kubeadm join ${aws_instance.k8s_master.0.private_ip}:6443 --token <your-token> --discovery-token-ca-cert-hash sha256:<your-hash>"
    EOT
  }

  depends_on = [null_resource.k8s_master_init]
}

# Step 3: Set Up Networking and Load Balancing
# 3.1 Create an ELB for the Kubernetes API
resource "aws_elb" "k8s_api_elb" {
  name               = "k8s-api-elb"
  availability_zones = data.aws_availability_zones.available.names

  listener {
    instance_port     = 6443
    instance_protocol = "TCP"
    lb_port           = 6443
    lb_protocol       = "TCP"
  }

  instances = aws_instance.k8s_master.*.id

  health_check {
    target              = "TCP:6443"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "k8s-api-elb"
  }
}

# 
