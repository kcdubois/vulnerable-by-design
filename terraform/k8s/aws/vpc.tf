locals {
  vpc_cidr_block = "172.20.0.0/16"
}

resource "random_string" "project" {
  length  = 12
  upper   = false
  lower   = true
  special = false
}

resource "aws_vpc" "prod" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${random_string.project.result}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "ca-central-1a"
  cidr_block        = "172.20.0.0/24"

  tags = {
    Name = "${random_string.project.result}-public-a"
    "kubernetes.io/role/elb" = 1
  }
}
resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "ca-central-1b"
  cidr_block        = "172.20.1.0/24"

  tags = {
    Name = "${random_string.project.result}-public-b"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "ca-central-1a"
  cidr_block        = "172.20.128.0/24"


  tags = {
    Name = "${random_string.project.result}-private-a"
    "kubernetes.io/role/internal-elb" = 1
  }
}
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "ca-central-1b"
  cidr_block        = "172.20.129.0/24"


  tags = {
    Name = "${random_string.project.result}-private-b"
    "kubernetes.io/role/internal-elb" = 1
  }
}

#
# Internet gateway for internet inbound access
#

resource "aws_internet_gateway" "prod" {
  tags = {
    Name = "igw-${random_string.project.result}"
  }
}

resource "aws_internet_gateway_attachment" "prod" {
  vpc_id              = aws_vpc.prod.id
  internet_gateway_id = aws_internet_gateway.prod.id
}

#
# Public route table for redirection to internet gateway
#

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = local.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod.id
  }

  tags = {
    Name = "route-${random_string.project.result}-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

#
# Private subnets route table for internet access
#

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = local.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "route-${random_string.project.result}-private"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

#
# Nat gateway for internet access to private subnets.
#
resource "aws_eip" "natgw" {
  tags = {
    Name = "natgw-eip-${random_string.project.result}"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "natgw-${random_string.project.result}"
  }
}