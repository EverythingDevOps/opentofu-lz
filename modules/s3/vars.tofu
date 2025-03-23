variable "bucket_name" {
  description = "Name of the S3 bucket for static storage"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

