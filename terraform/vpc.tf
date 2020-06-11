# VPC DESIGN

resource "aws_vpc" "billing" {
  cidr_block           = "172.${var.cidr_numeral}.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-billing"
  }
}

resource "aws_internet_gateway" "billing" {
  vpc_id = aws_vpc.billing.id

  tags = {
    Name = "igw-billing"
  }
}

resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  vpc   = true

  tags = {
    Name = "ip-NAT-billing-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  count  = length(var.availability_zones)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "gw-NAT-billing-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.billing.id

  cidr_block              = "172.${var.cidr_numeral}.${lookup(var.cidr_numeral_public, count.index)}.0/24"
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name               = "public-${count.index}-${var.vpc_name}"
    immutable_metadata = "{ \"purpose\": \"external_${var.vpc_name}\", \"target\": null }"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.billing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.billing.id
  }

  tags = {
    Name = "public-rt-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.billing.id

  cidr_block        = "172.${var.cidr_numeral}.${lookup(var.cidr_numeral_private, count.index)}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name               = "private-${count.index}-${var.vpc_name}"
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    Network            = "Private"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.billing.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name    = "private-rt-${count.index}-${var.vpc_name}"
    Network = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_subnet" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.billing.id

  cidr_block        = "172.${var.cidr_numeral}.${lookup(var.cidr_numeral_private_db, count.index)}.0/24"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name               = "db-private-${count.index}-${var.vpc_name}"
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    Network            = "Private"
  }
}

resource "aws_route_table" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.billing.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name    = "privatedb-rt-${count.index}-${var.vpc_name}"
    Network = "Private"
  }
}

resource "aws_route_table_association" "private_db" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(aws_route_table.private_db.*.id, count.index)
}
