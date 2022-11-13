resource "aws_security_group" "msk_sg" {
  name = "msk-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 9092
    to_port = 9094
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2181
    to_port = 2181
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
    Name = "msk-sg"
  }
}

resource "aws_cloudwatch_log_group" "msk_broker" {
  name = "msk_broker_logs"
}

resource "aws_msk_cluster" "default" {
  cluster_name           = "my-msk-cluster"
  kafka_version          = "3.2.0"
  number_of_broker_nodes = 2

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
  }

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    client_subnets = var.private_subnet_ids

    storage_info {
      ebs_storage_info {
        volume_size = 20
      }
    }
    security_groups = [aws_security_group.msk_sg.id]
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_broker.name
      }
    }
  }

  tags = {
    Name = "my-msk"
  }
}
