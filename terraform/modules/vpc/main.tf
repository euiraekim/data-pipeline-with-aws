resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block = "${var.public_subnet_cidrs[count.index]}"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.default.id
  
  cidr_block = "${var.private_subnet_cidrs[count.index]}"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.name}-private-subnet-${count.index}"
    Network = "Private"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "public_igw" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.name}-private-route-table-${count.index}"
    Network = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
