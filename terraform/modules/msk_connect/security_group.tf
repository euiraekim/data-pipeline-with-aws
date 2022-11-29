resource "aws_security_group" "msk_connect_sg" {
  name = "msk-connect-sg"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "msk-connect-sg"
  }
}
