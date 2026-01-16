resource "aws_instance" "wordpress" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    db_endpoint = aws_db_instance.wordpress.endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = {
    Name = "wordpress-server"
  }

  depends_on = [aws_db_instance.wordpress]
}
