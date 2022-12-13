resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier             = "postgresql"
  db_name                   = "postgresql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.7"
  skip_final_snapshot    = true
  publicly_accessible    = true

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.postgresql_security_group.id]
  username               = "testuser"
  password               = "Testpw1234"
}
