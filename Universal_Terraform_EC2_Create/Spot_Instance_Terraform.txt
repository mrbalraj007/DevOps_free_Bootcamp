provider "aws" {
  region = "us-east-1" # Change to your desired region
}


resource "aws_security_group" "spot_instance_sg" {
  name_prefix = "spot-instance-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open SSH access, restrict as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name = "Spot-EC2-SG"
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


resource "aws_instance" "spot_instance" {
  # ami             = "ami-0e2c8caa4b6378d8c" # Replace with your desired AMI ID
  ami                    = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"              # Replace with your desired instance type
 key_name               = "MYLABKEY" # Replace with your SSH key
  security_groups = [aws_security_group.spot_instance_sg.name]
user_data              = templatefile("user_data_jenkins.sh", {})
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.005" # Set your maximum price for the spot instance
    }
  }

  tags = {
    Name = "Spot-EC2-Instance"
  }
}

output "spot_instance_public_ip" {
  value = aws_instance.spot_instance.public_ip
}
