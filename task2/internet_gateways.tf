###################################
# Create all the internet gateways
###################################

## Internet gateway

resource "aws_internet_gateway" "internet_gateway_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-internet-gateway-1"
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