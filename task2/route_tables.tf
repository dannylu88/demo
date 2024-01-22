##############################
# Create all the route tables
##############################

## External route tables

resource "aws_route_table" "ext_route_table_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-ext-route-table-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
}

resource "aws_route_table" "ext_route_table_2" {
  vpc_id = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-ext-route-table-2"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
}

## Internal route tables

resource "aws_route_table" "int_route_table_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-int-route-table-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
}

resource "aws_route_table" "int_route_table_2" {
  vpc_id = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-int-route-table-2"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
}

############################
# Create route table routes
############################

## External route table 1 routes
resource "aws_route" "ext_route_table_1_route_1" {
  route_table_id         = aws_route_table.ext_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway_1.id
  depends_on             = [aws_route_table.ext_route_table_1]
}

## External route table 2 routes
resource "aws_route" "ext_route_table_1_route_2" {
  route_table_id         = aws_route_table.ext_route_table_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway_1.id
  depends_on             = [aws_route_table.ext_route_table_1]
}

## Internal route table 1 routes
resource "aws_route" "int_route_table_1_route_1" {
  route_table_id         = aws_route_table.int_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  depends_on             = [aws_route_table.int_route_table_1]
}

## Internal route table 2 routes
resource "aws_route" "int_route_table_1_route_2" {
  route_table_id         = aws_route_table.int_route_table_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  depends_on             = [aws_route_table.int_route_table_2]
}

##################################
# Create route table associations
##################################

## External route table associations

resource "aws_route_table_association" "ext_route_table_association_1" {
  subnet_id      = aws_subnet.ext_a_subnet_1.id
  route_table_id = aws_route_table.ext_route_table_1.id
}

resource "aws_route_table_association" "ext_route_table_association_2" {
  subnet_id      = aws_subnet.ext_b_subnet_1.id
  route_table_id = aws_route_table.ext_route_table_2.id
}
