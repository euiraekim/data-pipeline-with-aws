resource "aws_security_group" "elk_sg" {
  name = "elk-sg"
  vpc_id = module.vpc.vpc_id

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
    Name = "elk-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0c76973fbe0ee100c"
  instance_type               = "t2.small"
  key_name                    = "keykey"

  user_data = file("${path.module}/user_data.sh")

  subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.elk_sg.id]

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags = {
      Name    = "elk-instance-volume"
    }
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name    = "elk-bastion"
  }
}

resource "aws_instance" "private" {
  ami                         = "ami-0c76973fbe0ee100c"
  instance_type               = "t2.small"
  key_name                    = "keykey"

  user_data = file("${path.module}/user_data.sh")

  subnet_id      = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.elk_sg.id]

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags = {
      Name    = "elk-instance-volume"
    }
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name    = "elk-private"
  }
}

