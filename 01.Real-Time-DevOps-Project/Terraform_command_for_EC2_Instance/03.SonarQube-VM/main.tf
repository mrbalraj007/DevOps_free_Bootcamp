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

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.small"
  key_name               = "MYLABKEY"
  vpc_security_group_ids = [data.aws_security_group.Jenkins-VM-SG.id]
  user_data              = file("${path.module}/SonarQube-script.sh")

  tags = {
    Name = "Jenkins-SonarQube"
  }

  root_block_device {
    volume_size = 8
  }
}

data "aws_security_group" "Jenkins-VM-SG" {
  name = "Jenkins-VM-SG"
}

# This block ensures Terraform doesn't try to create a new security group
resource "null_resource" "prevent_sg_creation" {
  triggers = {
    security_group_id = data.aws_security_group.Jenkins-VM-SG.id
  }

  provisioner "local-exec" {
    command = "echo Existing security group ID: ${data.aws_security_group.Jenkins-VM-SG.id}"
  }
}
