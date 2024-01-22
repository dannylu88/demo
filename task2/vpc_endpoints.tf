###############################
# Create all the vpc endpoints
###############################

## S3 vpc endpoint
resource "aws_vpc_endpoint" "vpce_1" {
  vpc_id            = aws_vpc.vpc_1.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  tags = merge(
    {
      Name             = "${local.name_prefix}-s3-vpce-1"
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

######################################
# Vpc endpoint route table assocation
######################################

## External route table 1 association

resource "aws_vpc_endpoint_route_table_association" "vpce_1_association_1" {
  vpc_endpoint_id = aws_vpc_endpoint.vpce_1.id
  route_table_id  = aws_route_table.ext_route_table_1.id
}

## External route table 2 association

resource "aws_vpc_endpoint_route_table_association" "vpce_1_association_2" {
  vpc_endpoint_id = aws_vpc_endpoint.vpce_1.id
  route_table_id  = aws_route_table.ext_route_table_2.id
}

## Internal route table 1 association

resource "aws_vpc_endpoint_route_table_association" "vpce_1_association_3" {
  vpc_endpoint_id = aws_vpc_endpoint.vpce_1.id
  route_table_id  = aws_route_table.int_route_table_1.id
}

## Internal route table 2 association

resource "aws_vpc_endpoint_route_table_association" "vpce_1_association_4" {
  vpc_endpoint_id = aws_vpc_endpoint.vpce_1.id
  route_table_id  = aws_route_table.int_route_table_2.id
}