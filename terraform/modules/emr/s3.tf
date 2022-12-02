resource "aws_s3_bucket" "input_test" {
  bucket = "euiraekim-input-test"
}

resource "aws_s3_object" "user" {
  count = 2
  bucket = aws_s3_bucket.input_test.id
  key    = "User/User${count.index}.json"
  source = "User${count.index}.json"
}

resource "aws_s3_object" "order" {
  count = 1
  bucket = aws_s3_bucket.input_test.id
  key    = "Order/Order${count.index}.json"
  source = "Order${count.index}.json"
}
