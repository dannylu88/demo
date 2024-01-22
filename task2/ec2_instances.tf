####################################
# Create key pair for ec2 instances
####################################

resource "aws_key_pair" "ec2_kpr_1" {
  key_name   = "${local.name_prefix}-ec2-key-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGtVnYj7WaYA/vJjvSNZvCO0YJWfWZsL/MAkF0hgt0Ja1DE5N2EbJa89vnbuWGvz0QTRTf24hWuPpED8IxfV9DvbZZtj5yaEuAaAxLqrPxOBH4kDsVr0vimmGTG8FLdp53QYaRAW65AywHcyWPUQLjeOX6YWmvW/I8gEZvRZWBpjZ2Y+18ChdUY+3dtl8axdFS+PTH+XOeUjgkmmqPtA+j2owe48PAG7SX8MszZnOO0W466yTkkcR7awFoMm5UqiX7lOutQLFJn+6KXrP/eM44OQuR1Sq023Pb2z4831mYbHZo5fseVhQB3Zw9DAmzCKORg3Rkmh5tRO6/GO0abr73sBnZ20zmVpDURz0UQLH/6TBlXlmHG7QLs1sRNGLDCHU88r4HWz9XubCNb2hjdfEewgqSS6nIAev52hYPAcUhLCY6oJgILpcAo8q0tsj/fQocZNNbkSQ8nrTPJFeLqrTOQq4upByyDg1ix6rsfEl3eH7o0piKkCCXd8BTimfXz8qMsXZkZWKTGC0jMNZ+obSe6JlS4SDG+Khk10Am8KbQ6EoasYif9GHw67/zONsIXktLmVmaO8XWtkHiFvFO4ju8DkvjdANM/JjUWsVKkoQUcwZxt635VrLr0Dn5P+jfBtdjDFUPnFouJXENxfyOG4CbpvHHlu8yM86Hu9SmU49uzQ== mcathcar@GBLOHQV30000025"
  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-key-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}



###############################
# Create all the ec2 instances
###############################

## Ec2 01 -> We don't need this anymore. We will use autoscaling group instead

# resource "aws_instance" "ec2_1" {
#   ami           = var.base_image
#   instance_type = var.instance_type
#   key_name      = aws_key_pair.ec2_kpr_1.key_name
#   vpc_security_group_ids      = [aws_security_group.ec2_1.id]
#   subnet_id                   = aws_subnet.ext_a_subnet_1.id
#   user_data                   = templatefile("${path.module}/templates/ec2_userdata.tpl", {
#     hostname = "${local.name_prefix}-ec2-1"
#     region   = var.region
#   })
#   associate_public_ip_address = false
#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }
  
#   tags = merge(
#     {
#       Name             = "${local.name_prefix}-ec2-1"
#       CreationDateTime = timestamp()
#     },
#     local.resource_tags
#   )

#   volume_tags = merge(
#     {
#       Name             = "${local.name_prefix}-ec2-1"
#       CreationDateTime = timestamp()
#     },
#     local.resource_tags
#   )

#   lifecycle {
#     ignore_changes = [
#       tags["CreationDateTime"],
#       volume_tags["CreationDateTime"],
#       user_data
#     ]
#   }
# }