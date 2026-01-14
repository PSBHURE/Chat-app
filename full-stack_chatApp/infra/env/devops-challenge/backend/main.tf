provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_bucket_challange_state_lock" {
  bucket = "devops-challenge-terraform-backend-035238983996"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "terraform_state_lock_bucket"
  }
}