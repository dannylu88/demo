#################################
# Create all the security groups
#################################

## Ec2 1 Security Group
resource "aws_security_group" "ec2_1" {
  name        = "${local.name_prefix}-ec2-1"
  description = "${local.name_prefix} EC2 Security Group"
  vpc_id      = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
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

########################################
# Create all the sgsecurity group rules
########################################


## Ec2 security group rules
##Ingress
resource "aws_security_group_rule" "ec2_1_ingress_1_tcp" {
  type                      = "ingress"
  description               = "Terraform Managed"
  from_port                 = 8080
  to_port                   = 8080
  protocol                  = "tcp"
  cidr_blocks               = ["11.11.11.11/32"] # Example NLB IP
  security_group_id         = aws_security_group.ec2_1.id
}

resource "aws_security_group_rule" "ec2_1_ingress_1_ssh" {
  type                      = "ingress"
  description               = "Terraform Managed"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  cidr_blocks               = ["11.11.11.11/32"] # Some IP we want
  security_group_id         = aws_security_group.ec2_1.id
}

##Egress
resource "aws_security_group_rule" "ec2_1_egress_1_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_1.id
}