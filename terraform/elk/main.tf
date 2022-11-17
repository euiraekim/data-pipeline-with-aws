module "vpc" {
  source = "../modules/vpc"

  name = "eks-logstash"
  vpc_cidr = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24", "10.1.3.0/24"]
  private_subnet_cidrs = ["10.1.2.0/24", "10.1.4.0/24"]

}


data "aws_vpc" "msk_vpc" {
  filter {
    name = "tag:Name"
    values = ["msk-vpc"]
  }
}

data "aws_route_table" "msk_route_table" {
  filter {
    name = "tag:Name"
    values = ["msk-private-route-table"]
  }
}

module "vpc_peering" {
  source = "../modules/vpc_peering"

  requestor_vpc_id = module.vpc.vpc_id
  requestor_vpc_cidr = module.vpc.vpc_cidr
  requestor_route_table_ids = module.vpc.private_route_table_ids
  acceptor_vpc_id = data.aws_vpc.msk_vpc.id
  acceptor_vpc_cidr = data.aws_vpc.msk_vpc.cidr_block
  acceptor_route_table_ids = data.aws_route_table.msk_route_table.id

}
