output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}

output "security_group_id" {
  value = module.ec2_instance.security_group_id
}
