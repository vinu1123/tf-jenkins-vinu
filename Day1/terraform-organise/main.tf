resource "aws_instance" "ubuntu_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  # Ensure EC2 instance is created only after the key pair
  depends_on = [aws_key_pair.generated_key]

  tags = {
    Name = var.instance_name
  }
}
