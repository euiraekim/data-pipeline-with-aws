resource "aws_emr_cluster" "cluster" {
  name          = "emr-test-arn"
  release_label = "emr-6.6.0"
  applications  = ["Spark"]

  ec2_attributes {
    subnet_id                         = var.public_subnet_ids[0]
    additional_master_security_groups = aws_security_group.allow_access.id
    additional_slave_security_groups  = aws_security_group.allow_access.id
    emr_managed_master_security_group = aws_security_group.allow_access.id
    emr_managed_slave_security_group  = aws_security_group.allow_access.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
    key_name = "keykey"
  }

  master_instance_group {
    instance_type = "m4.large"
  }

  core_instance_group {
    instance_count = 2
    instance_type  = "m4.large"
  }

  configurations_json = <<EOF
  [
    {
      "Classification": "hadoop-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    },
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    }
  ]
EOF

  service_role = aws_iam_role.iam_emr_service_role.arn
}
