output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "aws_region" {
  description = "The AWS region where the cluster is deployed"
  value       = local.region
}
