resource "aws_security_group" "es" {
  name        = "my-elasticsearch-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
    ]
  }
}

resource "aws_elasticsearch_domain" "default" {
  domain_name           = "my-es"
  elasticsearch_version = "7.10"
 
  cluster_config {
    instance_type = "t3.medium.elasticsearch"
    instance_count = 2
    zone_awareness_enabled = true
  }
  
  vpc_options {
    subnet_ids = var.subnet_ids

    security_group_ids = [aws_security_group.es.id]
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp2"
  }
  tags = {
    Domain = "my-es"
  }
}
 
 
resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.default.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.default.arn}/*"
        }
    ]
}
POLICIES
}
