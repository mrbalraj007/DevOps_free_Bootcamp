provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# Variables
variable "instance_count" {
  default = 2 # Number of instances to create
}

variable "instance_type" {
  default = "t2.medium" # Default instance type
}

# Data source for fetching latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # For Ubuntu Instance.
    values = ["amzn2-ami-hvm-*-x86_64*"] # For Amazon Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
  owners = ["137112412989"] # Amazon owner ID for Amazon Linux AMIs
}

# Define scripts to be used as user data
locals {
  scripts = [

    file("A_Jenkins-Master-script.sh"), # For amazon Machine
    file("A_Docker-script.sh"),         # For amazon Machine
    #file("A_SonarQube-script.sh")       # For amanzon Machine

    #file("Jenkins-Master-script.sh"),   # For Ubuntu Machine
    #file("Jenkins-Agent-script.sh"),    # For Ubuntu Machine
    #file("SonarQube-script.sh")        # For Ubuntu Machine
  ]
}

# EC2 Instance resource
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  key_name      = "MYLABKEY" #change key name as per your setup
  instance_type = var.instance_type

  # User data script for each instance
  user_data = local.scripts[count.index]

  tags = {
    Name = "Project_SVR-Instance-${count.index + 1}"
  }
}

# Output IP addresses of instances
output "instance_ips" {
  value = [for instance in aws_instance.ec2_instance : instance.public_ip]
}
