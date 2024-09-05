provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

module "ec2_instance" {
  source         = "./modules/ec2_instance"
  instance_name  = "MyUbuntuInstance"
  instance_type  = "t2.micro"
  key_name       = "MYLABKEY"
  sg_name_prefix = "myapp-sg"
}

