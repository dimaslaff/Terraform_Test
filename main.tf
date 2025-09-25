terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "hachi" {
  bucket = var.bucket_name
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_acl" "hachi_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}