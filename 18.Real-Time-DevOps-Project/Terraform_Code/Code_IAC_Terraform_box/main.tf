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


# resource "aws_instance" "docker_svr" {
#   #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"
#   key_name               = "MYLABKEY" # Replace with your SSH key
#   vpc_security_group_ids = [aws_security_group.ProjectSG.id]
#   user_data              = templatefile("./scripts/user_data_docker.sh", {})
#   tags = {
#     Name = "docker-svr"
#   }
# }

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
   root_block_device {
    volume_size = 30
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

# output "docker_server_public_ip" {
#   value = aws_instance.docker_svr.public_ip
# }

output "Jenkins_server_public_ip" {
  value = aws_instance.jenkins_svr.public_ip
}
