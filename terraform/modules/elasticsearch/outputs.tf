output "arn" {
    value = aws_elasticsearch_domain.default.arn
} 
output "domain_id" {
    value = aws_elasticsearch_domain.default.domain_id
} 
output "domain_name" {
    value = aws_elasticsearch_domain.default.domain_name
} 
output "endpoint" {
    value = aws_elasticsearch_domain.default.endpoint
} 
output "kibana_endpoint" {
    value = aws_elasticsearch_domain.default.kibana_endpoint
}
