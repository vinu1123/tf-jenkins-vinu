variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "Access control list"
  type        = string
  default     = "private"
}
