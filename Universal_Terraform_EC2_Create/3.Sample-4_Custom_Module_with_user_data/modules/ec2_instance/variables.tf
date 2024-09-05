variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "security_group_id" {
  description = "ID of an existing security group"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "user_data" {
  description = "List of paths to user_data scripts"
  type        = list(string)
}
