resource "aws_autoscaling_group" "apache_tomcat" {
  name                 = "apache-tomcat"
  vpc_zone_identifier  = [aws_subnet.ext_a_subnet_1.id, aws_subnet.ext_b_subnet_1.id]
  min_size             = 2
  max_size             = 10
  #After attach target scaling policy, should leave this manage by AWS
  #desired_capacity     = NA  
  launch_configuration = aws_launch_configuration.apache_tomcat.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "apache_tomcat" {
  #do this so it won't say launch config already exist when terraform apply
  name_prefix = "apache-tomcat"  
  security_groups = [
    "${aws_security_group.ec2_1.id}",
  ]
  key_name                    = aws_key_pair.ec2_kpr_1.key_name
  image_id                    = var.base_image
  instance_type               = var.instance_type
  
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/templates/ec2_userdata.tpl", {
    hostname = "${local.name_prefix}-ec2-1"
    region   = var.region
  })

  root_block_device {
    volume_size           = 25
    volume_type           = "gp3"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "apache_tomcat" {
  name = "target-scaling-CPU around 60"
  autoscaling_group_name = aws_autoscaling_group.apache_tomcat.name
  adjustment_type = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }

  target_value = 60.0
  }
}

#NLB
resource "aws_lb" "apache_tomcat" {
  name               = "apache-tomcat-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets            = [aws_subnet.ext_a_subnet_1.id, aws_subnet.ext_b_subnet_1.id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}


resource "aws_lb_target_group" "apache_tomcat" {
  name     = "apache-tomcat"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc_1.id
  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}

resource "aws_lb_listener" "apache_tomcat" {
  load_balancer_arn = aws_lb.apache_tomcat.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = aws_acm_certificate.main.arn 
  alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache_tomcat.arn
  }
  
  tags = merge(
    {
      Name             = "${local.name_prefix}-ec2-1"
      CreationDateTime = timestamp()
    },
    local.resource_tags
  )
}