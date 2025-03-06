resource "aws_key_pair" "my_key" {
  key_name   = "my-key-arjun23"
  public_key = file("${path.module}/id_rsa.pub")
}
