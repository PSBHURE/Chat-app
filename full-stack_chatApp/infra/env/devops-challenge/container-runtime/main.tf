provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "../../../modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  ami_type             = var.ami_type
  instance_type        = var.instance_type
  volume_size          = var.volume_size
}

module "eks" {
  source = "../../../modules/eks"
  env                 = var.env
  cluster_version = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  node_groups = var.node_groups
#   default_tags = var.default_tags
}

