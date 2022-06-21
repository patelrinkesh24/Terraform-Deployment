# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

# Create a new VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}


# Add provisioning of the public subnetin the default VPC
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet-${count.index}"
    }
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  count = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "public_route_table" {
count = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = {
    Name = "${local.name_prefix}-route-public-route_table"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_route_table[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

# Add provisioning of the private subnetin the default VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}

resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-pnat-gw"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_eip" {
count = var.enable_nat_gateway ? 1 : 0
  vpc = true
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-nat-eip"
    }
  )
}


# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "private_route_table" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[0].id
  }
  tags = {
    Name = "${local.name_prefix}-route-private-route_table"
  }
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "private_route_table_without_ngw" {
  count = var.enable_nat_gateway ? 0 : 1
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.name_prefix}-route-private-route-table-without-ngw"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = var.enable_nat_gateway ? aws_route_table.private_route_table[0].id : aws_route_table.private_route_table_without_ngw[0].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
