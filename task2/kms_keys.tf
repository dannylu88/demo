########################
# Create kms key policy
########################

data "aws_iam_policy_document" "kms_key_policy_1" {
  policy_id = "Allow ${data.aws_caller_identity.current.account_id} to use the CMK"
  statement {
    sid = "EnableIAMUserPermissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
        "kms:*"
    ]
    resources = [        
        "*"
    ]
  }
  statement {
    sid = "AllowFlowLogstoS3"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [
          "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey"
    ]
    resources = [
        "*"
    ]

    condition {
      test     = "StringEquals"
      values   = [ data.aws_caller_identity.current.account_id ]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = [ "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*" ]
      variable = "aws:SourceArn"
    }
  }
}

##################
# Create kms keys
##################


## S3 kms key
resource "aws_kms_key" "kms_s3_key_1" {
  description             = "S3 KMS Key for ${var.code}"
  deletion_window_in_days = 10
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy_1.json
  tags = merge(
    {
      Name             = "${local.name_prefix}-s3-kms-1"
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

# S3 kms key alias
resource "aws_kms_alias" "kms_s3_key_alias_1" {
  name          = "alias/${local.name_prefix}-s3-kms-1"
  target_key_id = aws_kms_key.kms_s3_key_1.key_id
}