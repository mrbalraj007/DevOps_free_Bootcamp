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

# Create IAM Role
resource "aws_iam_role" "ha_lb_role" {
  name = "HA-LB"

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

# Attach Full EC2 Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.ha_lb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Attach Full IAM Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.ha_lb_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Create IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ha_lb_instance_profile" {
  name = "HA-LB-Instance-Profile"
  role = aws_iam_role.ha_lb_role.name
}

# Create two EC2 instances
resource "aws_instance" "k8s_proxy" {
  count                  = 2
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY"
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ha_lb_instance_profile.name
  user_data              = templatefile("./HA_Proxy_install.sh", {})

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "HA-Proxy-${count.index + 1}"
  }
}

# Create an Elastic IP for the first EC2 instance
resource "aws_eip" "ha_proxy_eip" {
  instance = aws_instance.k8s_proxy[0].id
}

# Create a security group
resource "aws_security_group" "k8s_sg" {
  name        = "k8s_security_group"
  description = "Security group for Kubernetes cluster"

  ingress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Etcd"
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTPS"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Docker API"
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTP with Auth"
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = 2000
    to_port     = 11000
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
    Name = "k8s_HA_Proxy_SG"
  }
}

output "instance_public_ips" {
  value = aws_instance.k8s_proxy[*].public_ip
}

output "instance_private_ips" {
  value = aws_instance.k8s_proxy[*].private_ip
}

# Output the Elastic IP
output "ha_proxy_eip" {
  value = aws_eip.ha_proxy_eip.public_ip
}
