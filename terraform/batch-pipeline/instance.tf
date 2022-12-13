resource "aws_security_group" "redash_sg" {
  name = "redash-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redash-sg"
  }
}

resource "aws_instance" "redash" {
  ami                         = "ami-0d991ac4f545a6b34"
  instance_type               = "t2.small"
  key_name                    = "keykey"

  subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.redash_sg.id]

  tags = {
    Name    = "redash"
  }
}
