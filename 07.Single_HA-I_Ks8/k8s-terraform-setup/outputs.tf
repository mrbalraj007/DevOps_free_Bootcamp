output "vpc_id" {
  value = aws_vpc.k8s_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnet[*].id
}

output "master_public_ips" {
  value = aws_instance.k8s_master[*].public_ip
}
