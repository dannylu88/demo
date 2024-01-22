#######################
# Create External NACL
#######################

resource "aws_network_acl" "external" {
  vpc_id = aws_vpc.vpc_1.id
  subnet_ids = [ aws_subnet.ext_a_subnet_1.id, aws_subnet.ext_b_subnet_1.id ]

  tags = merge(
    {
      Name             = "${local.name_prefix}-external-nacl"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}

#############################
# Create External NACL Rules
#############################
#
# Allow ICMP External

resource "aws_network_acl_rule" "allow_all_icmp_inbound_external" {
  network_acl_id = aws_network_acl.external.id
  rule_number = 100
  egress = false
  protocol = "icmp"
  rule_action = "allow"

  # External but says restict to rfc1918? :)
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities. Should restrict to rfc1918 ranges
  cidr_block = "0.0.0.0/0"
  icmp_type = -1
  icmp_code = -1
}

resource "aws_network_acl_rule" "allow_all_icmp_outbound_external" {
  network_acl_id = aws_network_acl.external.id
  rule_number = 100
  egress = true
  protocol = "icmp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  icmp_type = -1
  icmp_code = -1
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_1_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 500
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block ="0.0.0.0/0"
  to_port = 25
  from_port = 21
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_1_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 500
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 25
  from_port = 21
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_2_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 501
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 161
  from_port = 161
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_2_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 501
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 161
  from_port = 161
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_3_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 502
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 3389
  from_port = 3389
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_3_external" {

  network_acl_id = aws_network_acl.external.id
  rule_number = 502
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 3389
  from_port = 3389
}

#######################
# Create Internal NACL
#######################

resource "aws_network_acl" "internal" {
  vpc_id = aws_vpc.vpc_1.id
  subnet_ids = [ aws_subnet.int_a_subnet_1.id, aws_subnet.int_b_subnet_1.id ]

  tags = merge(
    {
      Name             = "${local.name_prefix}-internal-nacl"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}

#############################
# Create Internal NACL Rules
#############################

#
# Allow ICMP Internal

resource "aws_network_acl_rule" "allow_all_icmp_inbound_internal" {
  network_acl_id = aws_network_acl.internal.id
  rule_number = 100
  egress = false
  protocol = "icmp"
  rule_action = "allow"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities. Should restrict to rfc1918 ranges
  cidr_block = var.cidr_blocks["vpc"]
  icmp_type = -1
  icmp_code = -1
}

resource "aws_network_acl_rule" "allow_all_icmp_outbound_internal" {
  network_acl_id = aws_network_acl.internal.id
  rule_number = 100
  egress = true
  protocol = "icmp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  icmp_type = -1
  icmp_code = -1
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_1_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 500
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block ="0.0.0.0/0"
  to_port = 25
  from_port = 21
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_1_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 500
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 25
  from_port = 21
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_2_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 501
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 161
  from_port = 161
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_2_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 501
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 161
  from_port = 161
}

resource "aws_network_acl_rule" "drop_bad_ports_inbound_3_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 502
  egress = false
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 3389
  from_port = 3389
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_3_internal" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 502
  egress = true
  protocol = "tcp"
  rule_action = "deny"
  cidr_block = "0.0.0.0/0"
  to_port = 3389
  from_port = 3389
}


resource "aws_network_acl_rule" "allow_public_internal_ext_a_subnet_1" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 600
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = aws_subnet.ext_a_subnet_1.cidr_block
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_3_ext_a_subnet_1" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 502
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = aws_subnet.ext_a_subnet_1.cidr_block
}

resource "aws_network_acl_rule" "allow_public_internal_ext_b_subnet_1" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 600
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = aws_subnet.ext_b_subnet_1.cidr_block
}

resource "aws_network_acl_rule" "drop_bad_ports_outbound_3_ext_b_subnet1" {

  network_acl_id = aws_network_acl.internal.id
  rule_number = 502
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = aws_subnet.ext_b_subnet_1.cidr_block
}