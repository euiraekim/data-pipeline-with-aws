variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}


variable "msk_cluster_name" {
  type = string
}

variable "kafka_topics" {
  type = list(string)
}


