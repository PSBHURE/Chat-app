# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.env}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  # tags = var.default_tags
}

#  Attach IAM Policy to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create the EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-eks-cluster"
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
  # tags = var.default_tags
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.env}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  # tags = var.default_tags
}

# Attach IAM Policy to Worker Node Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", #EC2 Instance management
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", #Network in K8s
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" #ECR policy
  ])
  policy_arn = each.value
  role       = aws_iam_role.eks_node_role.name
}

#  Create EKS Node Group (Worker Nodes)
resource "aws_eks_node_group" "eks_nodes" {


  for_each = var.node_groups
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  instance_types = each.value.instance_types
  capacity_type = each.value.capacity_type
  labels = {
    "devops-challenge/nodegroup" ="app"
  }

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }
  
  depends_on = [ aws_iam_role_policy_attachment.eks_worker_node_policy ]
  
  # tags = var.default_tags
}