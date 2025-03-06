resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "arjun"
  }
}

variable "ami" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
