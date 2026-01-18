terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.93.0"
    }
  }
  backend "s3" {
    bucket       = "devops-challenge-terraform-backend-996099991963"
    key          = "dev/devops-challenge-container-infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #S3 native locking
  }
}