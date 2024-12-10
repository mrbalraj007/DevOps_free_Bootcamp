provider "aws" {
  region = "us-east-1" # Specify your desired region
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


resource "aws_instance" "ansible_svr" {
  #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY" # Replace with your SSH key
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_ansible.sh", {})
  tags = {
    Name = "Ansible-svr"
  }
}


resource "aws_instance" "docker_svr" {
  #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY" # Replace with your SSH key
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_docker.sh", {})
  tags = {
    Name = "docker-svr"
  }
}

resource "aws_instance" "jenkins_svr" {
  #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = "MYLABKEY" # Replace with your SSH key
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_jenkins.sh", {})
  tags = {
    Name = "jenkins_svr"
  }
}

resource "aws_instance" "tomcat_svr" {
  #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY" # Replace with your SSH key
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_tomcat.sh", {})
  tags = {
    Name = "tomcat_svr"
  }
}


# Security Group Configuration
resource "aws_security_group" "ProjectSG" {
  name        = "Project-SG"
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
    from_port   = 20000
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
    Name = "Project-VM-SG"
  }
}

# Separate EC2 Instance for Terraform with IAM Profile and Folder Copy
resource "aws_instance" "terraform_vm" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = "MYLABKEY"  # Change key name as per your setup
  instance_type          = "t3.medium" # Instance type for Terraform VM t2.large
  iam_instance_profile   = aws_iam_instance_profile.k8s_cluster_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ProjectSG.id]
  user_data              = templatefile("./scripts/user_data_terraform.sh", {})

  tags = {
    Name = "bootstrap-svr"
  }

  root_block_device {
    volume_size = 30
  }

  # Copy the k8s_setup_file folder after the instance is created
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

# Attach Full ElasticLoadBalancingFullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "elb_full_access" {
  role       = aws_iam_role.k8s_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}




output "Ansible_server_public_ip" {
  value = aws_instance.ansible_svr.public_ip
}

output "docker_server_public_ip" {
  value = aws_instance.docker_svr.public_ip
}

output "Jenkins_server_public_ip" {
  value = aws_instance.jenkins_svr.public_ip
}

output "tomcat_server_public_ip" {
  value = aws_instance.tomcat_svr.public_ip
}


output "terraform_vm_public_ip" {
  value = aws_instance.terraform_vm.public_ip
}
