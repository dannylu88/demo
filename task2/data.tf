#############################
# Collect data for resources
#############################

## Account id
data "aws_caller_identity" "current" {
}

## Aws elb account id for alb log delivery
data "aws_elb_service_account" "elb_account" {
}

## Get date
data "external" "date_time" {
  program = ["bash", "${path.root}/scripts/get_date.sh"]
}