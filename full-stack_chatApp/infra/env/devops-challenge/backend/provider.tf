terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=5.93.0"
    }
  }
  backend "s3" {
    bucket = "devops-challenge-terraform-backend-035238983996"
    key    = "dev/devops-challenge-terraform-backend/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}