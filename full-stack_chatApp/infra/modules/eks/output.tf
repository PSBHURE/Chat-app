output "cluster_endpoint" {
  description = "Endpoint of EKS cluster"
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  description = "name of EKS cluster"
  value       = aws_eks_cluster.eks.name
}