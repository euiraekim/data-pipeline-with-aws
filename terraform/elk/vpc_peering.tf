data "aws_vpc" "msk_vpc" {
  filter {
    name = "tag:Name"
    values = ["msk-vpc"]
  }
}

data "aws_route_table" "msk_public_route_table" {
  filter {
    name = "tag:Name"
    values = ["msk-public-route-table"]
  }
}

resource "aws_vpc_peering_connection" "default" {
  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = data.aws_vpc.msk_vpc.id
  
  auto_accept   =  true
}

resource "aws_route" "peering_to_msk" {
  count = length(module.vpc.public_route_table_ids)

  route_table_id = element(module.vpc.public_route_table_ids, count.index)

  destination_cidr_block = data.aws_vpc.msk_vpc.cidr_block

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

resource "aws_route" "peering_to_elk" {
  route_table_id = data.aws_route_table.msk_public_route_table.id

  destination_cidr_block = module.vpc.vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}
