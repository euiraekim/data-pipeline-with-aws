resource "aws_vpc_peering_connection" "default" {
  vpc_id        = var.requestor_vpc_id
  peer_vpc_id   = var.acceptor_vpc_id
  
  auto_accept   =  true
}

resource "aws_route" "requestor" {
  count = length(var.requestor_route_table_ids)

  route_table_id = element(var.requestor_route_table_ids, count.index)

  destination_cidr_block = var.acceptor_vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

resource "aws_route" "acceptor" {
  count = length(var.acceptor_route_table_ids)

  route_table_id = element(var.acceptor_route_table_ids, count.index)

  destination_cidr_block = var.requestor_vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}
