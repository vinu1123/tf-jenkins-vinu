resource "aws_instance" "app_server" {
  ami                    = "ami-09e143e99e8fa74f9"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # Use security group ID
  key_name               = aws_key_pair.my_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "arjun"
  }

  depends_on = [aws_security_group.web_sg]  # Ensure SG is created first
}
