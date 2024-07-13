data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

variable "instance_details" {
  default = [
    {
      name       = "Jenkins-Master"
      script     = "./Jenkins-Master-script.sh"
      assign_eip = true
    },
    {
      name       = "Jenkins-Agent"
      script     = "./Jenkins-Agent-script.sh"
      assign_eip = false
    },
    {
      name       = "SonarQube"
      script     = "./SonarQube-script.sh"
      assign_eip = false
    },
    {
      name       = "EKS-BootStrap"
      script     = "./EKS-BootStrap-script.sh"
      assign_eip = false
    }
  ]
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
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
    Name = "Jenkins-VM-SG"
  }
}

resource "aws_instance" "web" {
  count                  = length(var.instance_details)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = "MYLABKEY"
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]

  user_data = templatefile(element(var.instance_details, count.index).script, {})

  tags = {
    Name = element(var.instance_details, count.index).name
  }

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "web_eip" {
  count    = length([for instance in var.instance_details : instance if instance.assign_eip])
  instance = aws_instance.web[count.index].id
  vpc      = true
}
