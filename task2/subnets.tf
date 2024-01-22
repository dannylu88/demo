######################
# Create all the vpcs
######################

## Public subnet a
resource "aws_subnet" "ext_a_subnet_1" {
  vpc_id               = aws_vpc.vpc_1.id
  cidr_block           = var.cidr_blocks["ext_a"]
  availability_zone_id = var.availability_zone["zone_a_id"]
  tags = merge(
    {
      Name             = "${local.name_prefix}-exta-subnet-1"
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

## Public subnet b
resource "aws_subnet" "ext_b_subnet_1" {
  vpc_id               = aws_vpc.vpc_1.id
  cidr_block           = var.cidr_blocks["ext_b"]
  availability_zone_id = var.availability_zone["zone_b_id"]
  tags = merge(
    {
      Name             = "${local.name_prefix}-extb-subnet-1"
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

## Private subnet a
resource "aws_subnet" "int_a_subnet_1" {
  vpc_id               = aws_vpc.vpc_1.id
  cidr_block           = var.cidr_blocks["int_a"]
  availability_zone_id = var.availability_zone["zone_a_id"]
  tags = merge(
    {
      Name             = "${local.name_prefix}-inta-subnet-1"
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

## Private subnet b
resource "aws_subnet" "int_b_subnet_1" {
  vpc_id               = aws_vpc.vpc_1.id
  cidr_block           = var.cidr_blocks["int_b"]
  availability_zone_id = var.availability_zone["zone_b_id"]
  tags = merge(
    {
      Name             = "${local.name_prefix}-intb-subnet-1"
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