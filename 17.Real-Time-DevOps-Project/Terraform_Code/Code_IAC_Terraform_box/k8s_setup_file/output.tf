output "eks_cluster_name" {
  description = "The name of the EKS Cluster"
  value       = aws_eks_cluster.balraj_cluster.name
}

output "aws_region" {
  description = "The AWS region"
  value       = var.region
}