variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "my-terraform-bucket-12345-arjun1"
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable versioning for the S3 bucket"
  default     = true
}

variable "object_lifecycle_days" {
  type        = number
  description = "Number of days before objects are moved to Glacier"
  default     = 30
}

variable "allowed_regions" {
  type        = list(string)
  description = "List of allowed AWS regions"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags for the S3 bucket"
  default = {
    Environment = "Development"
    Owner       = "DevOps"
  }
}

variable "storage_class_config" {
  type = object({
    standard = string
    glacier  = string
  })
  description = "Storage class configurations"
  default = {
    standard = "STANDARD"
    glacier  = "GLACIER"
  }
}

variable "bucket_settings" {
  type        = tuple([string, number, bool])
  description = "Tuple containing [logging_bucket_name, logging_retention_days, logging_enabled]"
  default     = ["my-log-bucket-arjun122", 90, true]
}
