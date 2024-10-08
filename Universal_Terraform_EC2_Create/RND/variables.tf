# variables.tf

# AWS region (e.g., us-east-1)
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

# SSH key name
variable "key_name" {
  description = "The name of the SSH key pair."
  type        = string
  default     = "MYLABKEY"
}

# # Path to the public SSH key
# variable "public_key_path" {
#   description = "Path to the public SSH key."
#   type        = string
#   default     = "~/.ssh/id_rsa.pub"
# }

# # Path to the private SSH key
# variable "private_key_path" {
#   description = "Path to the private SSH key."
#   type        = string
#   default     = "~/.ssh/id_rsa"
# }

# EC2 instance type
variable "instance_type" {
  description = "Type of EC2 instance."
  type        = string
  default     = "t2.micro"
}

# CIDR block allowed to SSH into the instance (e.g., your IP)
variable "allowed_ssh_cidr" {
  description = "CIDR block that is allowed to SSH into the EC2 instance."
  type        = string
  default     = "155.190.55.6/32" # Replace with your actual IP

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.allowed_ssh_cidr))
    error_message = "allowed_ssh_cidr must be a valid CIDR block."
  }
}

# Password for the Balraj user (sensitive)
variable "balraj_password" {
  description = "Password for the Balraj user."
  type        = string
  sensitive   = true
}
