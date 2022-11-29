resource "aws_iam_role" "msk_connect_s3" {
  name               = "msk-connect-s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "kafkaconnect.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "msk_connect_s3_policy" {
  name   = "msk-connect-s3-policy"
  role   = aws_iam_role.msk_connect_s3.id
  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "AllowAccessS3",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.kafka_topics.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.kafka_topics.bucket}/*",
        "arn:aws:s3:::${aws_s3_bucket.msk_connect_source.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.msk_connect_source.bucket}/*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF

}
