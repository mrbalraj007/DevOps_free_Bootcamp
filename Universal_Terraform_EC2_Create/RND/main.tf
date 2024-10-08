# main.tf

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to find the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# # Create an SSH key pair
# resource "aws_key_pair" "jenkins_key" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }

# Create a security group to allow SSH and Jenkins UI access
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and Jenkins UI access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For production, restrict this to trusted IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

# Launch an EC2 instance with Jenkins installed
resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  # Provide the user data script to install Jenkins and create user Balraj
  user_data = templatefile("${path.module}/install_jenkins.sh.tpl", {
    balraj_password = var.balraj_password
  })

  tags = {
    Name = "JenkinsServer"
  }

  # Output the public IP after creation
  provisioner "local-exec" {
    command = "echo Jenkins instance created with public IP: ${self.public_ip}"
  }
}

# Verification: Check if Jenkins UI is accessible using remote-exec
resource "null_resource" "verify_jenkins_ui" {
  provisioner "remote-exec" {
    inline = [
      <<-EOT
        #!/bin/bash
        for i in {1..30}; do
          HTTP_STATUS=$(curl -s -o /dev/null -w "%%{http_code}" http://localhost:8080)
          if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 401 ]; then
            echo "Jenkins UI is accessible."
            exit 0
          fi
          echo "Waiting for Jenkins UI to become accessible..."
          sleep 10
        done
        echo "Jenkins UI is not accessible after waiting."
        exit 1
      EOT
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.PEM")
      host        = aws_instance.jenkins.public_ip
    }
  }

  depends_on = [aws_instance.jenkins]
}
