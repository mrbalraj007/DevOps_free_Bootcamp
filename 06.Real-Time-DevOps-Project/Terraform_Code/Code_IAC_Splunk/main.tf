data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # For Ubuntu Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

resource "aws_instance" "splunk" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = "MYLABKEY" # Change key name as per your setup
  vpc_security_group_ids = [aws_security_group.splunk-VM-SG.id]
  user_data              = templatefile("./Splunk_install.sh", {})

  tags = {
    Name = "Splunk-SVR"
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "splunk-VM-SG" {
  name        = "splunk-VM-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "splunk-VM-SG"
  }
}

output "instance_ip" {
  value = aws_instance.splunk.public_ip
}
