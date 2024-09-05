variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name to use for the instance"
  type        = string
}

variable "sg_name_prefix" {
  description = "Prefix for the security group name"
  type        = string
  default     = "ec2-sg"
}
