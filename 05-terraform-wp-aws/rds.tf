# Subnet Group pour RDS (nécessite au moins 2 subnets dans 2 AZs différentes)
resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-db-subnet"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_2.id]

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

# Instance RDS
resource "aws_db_instance" "wordpress" {
  identifier             = "wordpress-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name = "wordpress-db"
  }
}
