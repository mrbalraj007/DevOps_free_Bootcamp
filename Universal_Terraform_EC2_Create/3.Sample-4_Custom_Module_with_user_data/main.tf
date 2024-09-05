module "ec2_instances" {
  source = "./modules/ec2_instance"

  instance_count      = 2
  instance_type       = "t2.micro"
  key_name            = "MYLABKEY"
  security_group_name = "my-security-group"
  security_group_id   = aws_security_group.sg.id
  instance_name       = "server"
  region              = "us-east-1"

  user_data = [
    "${path.module}/scripts/jenkins.sh",
    "${path.module}/scripts/docker.sh"
  ]
}

resource "aws_security_group" "sg" {
  name        = "my-security-group1"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
