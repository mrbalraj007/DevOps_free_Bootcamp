output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.this[*].id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}
