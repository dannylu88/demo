######################
# Create all the vpcs 
######################

## Vpc 1
resource "aws_vpc" "vpc_1" {
  cidr_block           = var.cidr_blocks["vpc"]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name             = "${local.name_prefix}-vpc-1"
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

######################
# Create vpc flow log 
######################

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_s3_bucket.s3_bucket_1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc_1.id
}