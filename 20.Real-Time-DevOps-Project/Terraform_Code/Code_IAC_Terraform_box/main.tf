terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = var.region_name
}

# To Create Security Group for EC2 Instance 
resource "aws_security_group" "ProjectSG" {
  name        = "JENKINS-SERVER-SG"
  description = "Jenkins Server Ports"

  dynamic "ingress" {
    for_each = toset([22, 25, 80, 443, 3000, 6443, 465, 27017])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Port 2379-2380 is required for etcd-cluster
  ingress {
    description = "etc-cluster Port"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range 30000 to 32767"
    from_port   = 20000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 10250-10260 is required for K8s
  ingress {
    description = "K8s Ports"
    from_port   = 10250
    to_port     = 10260
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define outbound rules to allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "JENKINS-SVR-SG"
  }

}

# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"] # For Ubuntu Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Separate EC2 Instance for Terraform with IAM Profile and Folder Copy
resource "aws_instance" "terraform_vm" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = var.key_name      # Change key name as per your setup
  instance_type          = var.instance_type # Instance type for Terraform VM t2.large
  iam_instance_profile   = aws_iam_instance_profile.k8s_cluster_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_terraform.sh", {})

  tags = {
    Name = var.server_name
  }

  root_block_device {
    volume_size = var.volume_size
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.0251" # Set your maximum price for the spot instance
    }
  }


  # Copy the k8s_setup_file folder after the instance is created
  provisioner "file" {
    source      = "./k8s_setup_file"
    destination = "/home/ubuntu/k8s_setup_file"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }

  # Set appropriate ownership for the copied folder
  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s_setup_file"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }
}

# Custom IAM Policy for EKS with full permissions
resource "aws_iam_policy" "eks_custom_policy" {
  name        = "eks_custom_policy"
  description = "Custom policy for EKS operations with full permissions"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "eks:*",
        Resource = "*"
      }
    ]
  })
}


# Attach Custom EKS Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks_custom_policy_attachment" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = aws_iam_policy.eks_custom_policy.arn
}

# Create IAM Role
resource "aws_iam_role" "k8s_cluster_role" {
  name = "Role_k8s_cluster"

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

# Create IAM permissions

# Create Profile for EC2 
resource "aws_iam_instance_profile" "k8s_cluster_instance_profile" {
  name = "Role_k8s_cluster-Profile"
  role = aws_iam_role.k8s_cluster_role.name
}

# Attach Full AmazonEKSClusterPolicy Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "eks_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach Full AmazonEKSServicePolicy Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "eksservice_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# # Attach Full AmazonEC2ContainerRegistryReadOnly Services Permissions to IAM Role
# resource "aws_iam_role_policy_attachment" "containerreg_full_access" {
#   role       = aws_iam_role.k8s_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

# Attach Full AdministratorAccess Services Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "AdministratorAccess_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach Full AmazonEKSWorkerNodePolicy Services Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "ekswork_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach Full AmazonEKS_CNI_Policy Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "ekscni_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach Full AmazonEC2FullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Attach Full IAMFullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Attach Full AmazonVPCFullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# Attach Full ElasticLoadBalancingFullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "elb_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}



output "terraform_vm_public_ip" {
  value = aws_instance.terraform_vm.public_ip
}

output "terraform_vm_private_ip" {
  value = aws_instance.terraform_vm.private_ip
}
