output "eks_cluster_name" {
  value = module.eks.cluster_name
}

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "Docker_Server_IP" {
  value = module.vpc.Docker_Server_IP
}

output "Jenkins_Server_IP" {
  value = module.vpc.Jenkins_Server_IP
}