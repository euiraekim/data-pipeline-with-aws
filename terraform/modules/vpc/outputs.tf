output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_name" {
  value = aws_vpc.default.name
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
