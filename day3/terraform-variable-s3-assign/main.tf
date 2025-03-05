provider "aws" {
  region = var.allowed_regions[0] # Using the first region from the list
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    id     = "move-to-glacier"
    status = "Enabled"

    transition {
      days          = var.object_lifecycle_days
      storage_class = var.storage_class_config.glacier
    }
  }
}

# Create the log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_settings[0] # Name of the log bucket
}

# Set Object Ownership (Fixes ACL Issue)
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred" # Allows ACL usage
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_bucket.id}/logs/*",
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:s3:::${aws_s3_bucket.example.id}"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.log_bucket]
}

resource "aws_s3_bucket_logging" "logging" {
  count = var.bucket_settings[2] ? 1 : 0  # Enable logging only if true

  bucket        = aws_s3_bucket.example.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "logs/"

  depends_on = [
    aws_s3_bucket.log_bucket,
    aws_s3_bucket_policy.log_bucket_policy,
    aws_s3_bucket_ownership_controls.log_bucket_ownership
  ]
}
