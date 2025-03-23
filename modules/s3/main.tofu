resource "aws_s3_bucket" "static_storage" {
  bucket = var.bucket_name
  
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_storage" {
  depends_on = [aws_s3_bucket_ownership_controls.static_storage]
  bucket = aws_s3_bucket.static_storage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static_storage" {
  bucket                  = aws_s3_bucket.static_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.environment}-s3-access-policy"
  description = "Policy to allow access to the static storage S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.static_storage.arn,
          "${aws_s3_bucket.static_storage.arn}/*"
        ]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.static_storage.id
}

output "bucket_arn" {
  value = aws_s3_bucket.static_storage.arn
}

output "s3_access_policy_arn" {
  value = aws_iam_policy.s3_access.arn
}
