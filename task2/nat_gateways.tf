#####################################
# Create Elastic IPs for Nat Gateway
#####################################

## Eip 1
resource "aws_eip" "eip_1" {
  # vpc = true -> deprecated
  tags = merge(
    {
      Name             = "${local.name_prefix}-eip-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
  depends_on             = [aws_internet_gateway.internet_gateway_1]
}

#####################
# Create Nat Gateway
#####################
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.ext_a_subnet_1.id

  tags = merge(
    {
      Name             = "${local.name_prefix}-nat-gateway-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
  lifecycle {
    ignore_changes = [
      tags["CreationDateTime"]
    ]
  }
  depends_on = [aws_internet_gateway.internet_gateway_1]
}