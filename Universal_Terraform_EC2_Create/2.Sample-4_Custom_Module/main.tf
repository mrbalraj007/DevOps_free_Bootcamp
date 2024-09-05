provider "aws" {
  region = "us-east-1" # Specify your desired region
}

module "ec2_instances" {
  source         = "./modules/ec2_instance"
  instance_count = 2
  instance_type  = "t2.micro"
  key_name_value = "MYLABKEY"
  vpc_id         = "vpc-3aa9b743"    # Replace with your VPC ID
  subnet_id      = "subnet-1175424b" # Replace with your Subnet ID
}

