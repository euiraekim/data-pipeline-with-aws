resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = var.public_subnet_ids
  tags = {
    Name = "redshift-subnet-group"
  }
}

resource "aws_redshift_cluster" "default" {
  cluster_identifier = "redshift-test"
  database_name      = "redshift_test"
  master_username    = "testuser"
  master_password    = "Testpw1234"
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]

  skip_final_snapshot = true
  iam_roles = ["${aws_iam_role.redshift_role.arn}"]
}
