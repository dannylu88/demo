resource "aws_route53_zone" "main" {
  name = "some.example.sony.com"
  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}

resource "aws_acm_certificate" "main" {
  domain_name       = "some.example.sony.com"
  validation_method = "DNS"

  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_route53_zone.main ]
}