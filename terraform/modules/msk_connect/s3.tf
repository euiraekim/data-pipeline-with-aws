resource "aws_s3_bucket" "kafka_topics" {
  bucket = "euiraekim-kafka-topics"
}


resource "aws_s3_bucket" "msk_connect_source" {
  bucket = "euiraekim-msk-connect"
}

resource "aws_s3_object" "msk_connect_source" {
  bucket = aws_s3_bucket.msk_connect_source.id
  key    = "confluentinc-kafka-connect-s3-10.3.0.zip"
  source = "confluentinc-kafka-connect-s3-10.3.0.zip"
}
