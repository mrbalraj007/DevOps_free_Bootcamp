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


resource "aws_instance" "terraform_svr" {
  #ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 AMI for us-east-1, change based on your region
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "MYLABKEY" # Replace with your SSH key
  vpc_security_group_ids = [aws_security_group.TerraBox.id]
  user_data              = templatefile("./scripts/user_data_terraform.sh", {})
  tags = {
    Name = "Terraform-svr"
  }

  # Copy the spotify folder after the instance is created
  provisioner "file" {
    source      = "spotify"
    destination = "/home/ubuntu/spotify"

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
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/spotify"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("MYLABKEY.pem")
      host        = self.public_ip
    }
  }
}

# Security Group Configuration
resource "aws_security_group" "TerraBox" {
  name        = "Terra-VM-SG"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = toset([22,27228])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # ingress {
  #   description = "Custom TCP Port Range"
  #   from_port   = 3000
  #   to_port     = 10000
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "Custom TCP Port Range 30000 to 32767"
  #   from_port   = 20000
  #   to_port     = 32767
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terra-VM-SG"
  }
}


output "terraform_server_public_ip" {
  value = aws_instance.terraform_svr.public_ip
}
