provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "demo" {
  bucket = "dev-infra-cicd-bucket"
  force_destroy = true
}
