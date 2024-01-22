variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "code" {
 type        = string
 description = "friendly identifier for Name tag for resources"
 default     = "task2" 
}

variable "cidr_blocks" {
  type        = map(string)
  description = "A Map of CIDR formated strings used for VPC CIDR and Subnets"
  default     = {
    "vpc"   = "10.9.0.0/16"
    "int_a" = "10.9.0.0/24"
    "int_b" = "10.9.1.0/24"
    "ext_a" = "10.9.10.0/24"
    "ext_b" = "10.9.11.0/24"
  }
}
  
variable "availability_zone" {
  type        = map(string)
  description = "A Map of region specific Avaiability Zones"
  default     = {
    "zone_a" = "eu-west-2a"
    "zone_b" = "eu-west-2b"
    "zone_c" = "eu-west-2c"
    "zone_a_id" = "euw2-az2"
    "zone_b_id" = "euw2-az3"
    "zone_c_id" = "euw2-az1"
  }
}

variable "ssh_public_key_data" {
  type    = string
  default = null
}

variable "instance_type" {
  default = "t2.micro"
}

variable "base_image" {
  type        = string
  description = "AMI ID for base image for EC2 instances - http://cloud-images.ubuntu.com/locator/ec2/"
  default     = "ami-0493e28e0af3e55b5"
}

## Set local variables  -> Moved to its local.tf file, shouldn't exist in variables.tf
# locals {
#   name_prefix   = "${lower(var.code)}"
#   resource_tags = {
#     "Task"        = var.code
#   }
#   rfc1918 = [
#     "10.0.0.0/8",
#     "172.16.0.0/12",
#     "192.168.0.0/16"
#   ]
# }