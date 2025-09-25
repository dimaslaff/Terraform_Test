variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

variable "bucket_name" {
  description = "The unique name for the S3 bucket."
  type        = string
}

variable "environment" {
  description = "Target deployment environment (dev, staging, or prod)."
  type        = string
}
