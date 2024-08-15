# Data source for fetching latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # For Ubuntu Instance.
    #values = ["amzn2-ami-hvm-*-x86_64*"] # For Amazon Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
  # owners = ["137112412989"] # Amazon owner ID for Amazon Linux AMIs
}

# Create two EC2 instances
resource "aws_instance" "k8s_master" {
  count = 1
  # ami           = "ami-04a81a99f5ec58529" # Replace with the latest Ubuntu AMI ID for your region
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY" # Reference your existing key
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  user_data              = templatefile("./install.sh", {})

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "k8s-master-${count.index + 1}"
  }

}

# Create two EC2 instances
resource "aws_instance" "k8s_worker" {
  count = 1
  # ami           = "ami-04a81a99f5ec58529" # Replace with the latest Ubuntu AMI ID for your region
  instance_type          = "t2.micro"  # t2.medium
  key_name               = "MYLABKEY" # Reference your existing key
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  user_data              = templatefile("./install.sh", {})

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }

}

# Create a security group
resource "aws_security_group" "k8s_sg" {
  name        = "k8s_Master_worker_security_group"
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
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    description = "Etcd"
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
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
    cidr_blocks = ["172.31.0.0/16"]
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
    Name = "k8s_Master_worker_SG"
  }
}



output "master_instance_public_ips" {
  value = aws_instance.k8s_master[*].public_ip
}

output "master_instance_private_ips" {
  value = aws_instance.k8s_master[*].private_ip
}


output "worker_instance_public_ips" {
  value = aws_instance.k8s_worker[*].public_ip
}

output "worker_instance_private_ips" {
  value = aws_instance.k8s_worker[*].private_ip
}
