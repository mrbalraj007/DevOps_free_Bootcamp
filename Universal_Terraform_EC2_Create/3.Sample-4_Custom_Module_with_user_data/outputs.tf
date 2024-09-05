output "instance_ids" {
  value = module.ec2_instances.instance_ids
}

output "security_group_id" {
  value = module.ec2_instances.security_group_id
}
