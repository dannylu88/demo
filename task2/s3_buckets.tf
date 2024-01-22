######################
# Set local variables
######################

locals {
  account_id = data.aws_caller_identity.current.account_id
}

####################
# Create s3 buckets
####################

#Vpc flow log bucket
resource "aws_s3_bucket" "s3_bucket_1" {
  bucket        = "${local.account_id}-${local.name_prefix}-vpc-flow-logs"
  # acl           = "private" -> Deprecated, need aws_s3_bucket_acl
  force_destroy = true

  # server_side_encryption_configuration {  -> Deprecated
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }

  # versioning {  -> Deprecated
  #   enabled = false
  # }

  tags = merge(
    {
      Name             = "${local.name_prefix}-vpc-flow-logs"
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


####################
# s3 buckets acl
####################
resource "aws_s3_bucket_ownership_controls" "s3_bucket_1" {
  bucket = aws_s3_bucket.s3_bucket_1.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_1" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_1]

  bucket = aws_s3_bucket.s3_bucket_1.id
  acl    = "private"
}

####################
# s3 buckets versioning
####################
resource "aws_s3_bucket_versioning" "s3_bucket_1" {
  bucket = aws_s3_bucket.s3_bucket_1.id
  versioning_configuration {
    status = "Enabled"
  }
}

####################
# s3 server_side_encryption
####################
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_1" {
  bucket = aws_s3_bucket.s3_bucket_1.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_s3_key_1.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
