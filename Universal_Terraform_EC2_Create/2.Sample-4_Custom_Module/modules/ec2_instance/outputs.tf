output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.this[*].id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}
