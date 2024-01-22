terraform {
  required_version = ">= 1.0.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55"
      # bump to 4.55
      # 3.42 is a super old provider and doesn't support lots of s3 functionality
      # version = "=3.42" 
    }
  }
  backend "s3" {
    # This bucket must exist before we run this terraform
    bucket = "terraform-remote-state"
    key = "apache-tomcat"
  }
}

provider "aws" {
  region = var.region
}
