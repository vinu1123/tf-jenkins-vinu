terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

# Input Variables
variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "myterraformbucket"
}

variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Enable versioning for stage and prod environments"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to the bucket"
  type        = map(string)
  default = {
    Project     = "Terraform-Assignment"
    ManagedBy   = "Terraform"
  }
}

# Random suffix for uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# S3 Bucket Resource
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${lower(var.bucket_name)}-${random_string.suffix.result}"
  tags = merge(
    var.tags,
    {
      Name        = "${var.bucket_name}-${var.environment}"
      Environment = var.environment
    }
  )
}

# S3 Bucket Versioning (Conditional Expression)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = var.environment == "stage" || var.environment == "prod" ? "Enabled" : "Suspended"
  }
}



# Lifecycle Rule - Delete objects after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "delete-old-objects"
    status = "Enabled"

    filter {}

    expiration {
      days = 30
    }
  }
}

# Output Variables
output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}
