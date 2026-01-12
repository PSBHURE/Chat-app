aws_region      = "us-east-1"
env             = "dev"
vpc_cidr        = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
cluster_version = "1.30"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

node_groups = {
  "general" = {
    instance_types = ["t2.medium"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 1
      max_size     = 2
      min_size     = 1
    }
  }
}

