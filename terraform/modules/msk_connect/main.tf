data "aws_msk_cluster" "default" {
  cluster_name = var.msk_cluster_name
}

resource "aws_mskconnect_connector" "msk-connect-s3" {
  count = length(var.kafka_topics)

  name = "msk-connect-s3-${var.kafka_topics[count.index]}"

  kafkaconnect_version = "2.7.1"

  capacity {
    provisioned_capacity {
      mcu_count    = 1
      worker_count = 2
    }
  }

  connector_configuration = {
    "connector.class" = "io.confluent.connect.s3.S3SinkConnector"
    "s3.region": "ap-northeast-2"
    "key.converter": "org.apache.kafka.connect.json.JsonConverter"
    "value.converter": "org.apache.kafka.connect.json.JsonConverter"
    "key.converter.schemas.enable": "false"
    "value.converter.schemas.enable": "false"
    "format.class": "io.confluent.connect.s3.format.json.JsonFormat"
    "flush.size": "10"
    "schema.compatibility": "NONE"
    "topics": var.kafka_topics[count.index]
    "tasks.max": "2"
    "partitioner.class": "io.confluent.connect.storage.partitioner.TimeBasedPartitioner"
    "storage.class": "io.confluent.connect.s3.storage.S3Storage"
    "s3.bucket.name": aws_s3_bucket.kafka_topics.bucket

    "locale": "KR"
    "timezone": "UTC"
    "partition.duration.ms": "600000"
    "path.format": "YYYY-MM-dd/HH"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = data.aws_msk_cluster.default.bootstrap_brokers

      vpc {
        security_groups = [aws_security_group.msk_connect_sg.id]
        subnets         = var.private_subnet_ids
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "PLAINTEXT"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.msk_connect_s3_plugin.arn
      revision = aws_mskconnect_custom_plugin.msk_connect_s3_plugin.latest_revision
    }
  }

  service_execution_role_arn = aws_iam_role.msk_connect_s3.arn
}


resource "aws_mskconnect_custom_plugin" "msk_connect_s3_plugin" {
  name         = "s3-connect-plugin"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.msk_connect_source.arn
      file_key   = aws_s3_object.msk_connect_source.key
    }
  }
}
