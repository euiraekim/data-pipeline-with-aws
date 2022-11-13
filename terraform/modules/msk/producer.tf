resource "aws_security_group" "msk_producer_sg" {
  name = "msk-producer-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
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
    Name = "msk-producer-sg"
  }
}

resource "aws_instance" "producer-ec2" {
  ami                         = "ami-0c76973fbe0ee100c"
  instance_type               = "t2.small"
  key_name                    = "keykey"

  user_data = file("${path.module}/user_data.sh")

  associate_public_ip_address = true
  subnet_id      = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.msk_producer_sg.id]

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags = {
      Name    = "producer-volume"
    }
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name    = "producer-ec2"
  }
}
