provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source           = "./ec2_instance"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  private_key_path = var.private_key_path
}

module "eks_cluster" {
  source = "./eks_cluster"
  region = var.region
}
