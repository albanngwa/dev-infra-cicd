provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "dev_bucket" {
  bucket = "dev-infra-cicd-bucket2025"
  force_destroy = true
}
# adding this line