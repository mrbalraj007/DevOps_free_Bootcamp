output "cluster_id" {
  value = aws_eks_cluster.balraj.id
}

output "node_group_id" {
  value = aws_eks_node_group.balraj.id
}

output "vpc_id" {
  value = aws_vpc.balraj_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.balraj_subnet[*].id
}