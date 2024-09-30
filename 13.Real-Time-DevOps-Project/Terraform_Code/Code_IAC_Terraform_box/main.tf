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

# # Custom IAM Policy for EKS
# resource "aws_iam_policy" "eks_custom_policy" {
#   name        = "eks_custom_policy"
#   description = "Custom policy for EKS operations"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "eks:CreateNodegroup",
#           "eks:DescribeNodegroup",
#           "eks:DeleteNodegroup",
#           "eks:ListNodegroups",
#           "eks:CreateCluster",
#           "eks:DescribeCluster",
#           "eks:DeleteCluster",
#           "eks:ListClusters"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

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

# Attach Full AmazonEC2ContainerRegistryReadOnly Services Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "containerreg_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
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
# # Attach Full AutoScalingFullAccess Permissions to IAM Role
# resource "aws_iam_role_policy_attachment" "scale_full_access" {
#   role       = aws_iam_role.k8s_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
# }
# Attach Full ElasticLoadBalancingFullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "elb_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

# Create Profile for EC2 
resource "aws_iam_instance_profile" "k8s_cluster_instance_profile" {
  name = "Role_k8s_cluster-Profile"
  role = aws_iam_role.k8s_cluster_role.name
}

# # Attach Full Route53 Permissions to IAM Role
# resource "aws_iam_role_policy_attachment" "route_full_access" {
#   role       = aws_iam_role.k8s_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
# }

# # Attach Full S3 Permissions to IAM Role
# resource "aws_iam_role_policy_attachment" "s3_full_access" {
#   role       = aws_iam_role.k8s_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }


resource "aws_instance" "terrabox" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large" # EC2 size as per your requirement
  key_name               = "MYLABKEY" # Change key name as per your setup
  vpc_security_group_ids = [aws_security_group.TerraBox.id]
  iam_instance_profile   = aws_iam_instance_profile.k8s_cluster_instance_profile.name
  user_data              = templatefile("./terrabox_install.sh", {})

  tags = {
    Name = "terrabox-SVR"
  }

  root_block_device {
    volume_size = 30
  }

  # Copy the folder after the instance is created and SSH is available
  provisioner "file" {
    source      = "k8s_setup_file"
    destination = "/home/ubuntu/k8s_setup_file"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }

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

resource "aws_security_group" "TerraBox" {
  name        = "terra-VM-SG"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = toset([22, 25, 80, 443, 6443, 465, 27017])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
    from_port   = 30000
    to_port     = 32767
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
    Name = "terra-VM-SG"
  }
}

output "instance_ip" {
  value = aws_instance.terrabox.public_ip
}
