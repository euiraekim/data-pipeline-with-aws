variable "requestor_vpc_id" {
  type = string
}

variable "requestor_vpc_cidr" {
  type = string
}

variable "requestor_route_table_ids" {
  type = list(string)
}


variable "acceptor_vpc_id" {
  type = string
}

variable "acceptor_vpc_cidr" {
  type = string
}

variable "acceptor_route_table_ids" {
  type = list(string)
}
