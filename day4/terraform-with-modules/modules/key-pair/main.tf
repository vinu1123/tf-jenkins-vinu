resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

variable "key_name" {}
variable "public_key" {}

output "key_name" {
  value = aws_key_pair.my_key.key_name
}
