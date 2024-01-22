locals {
  name_prefix   = "${lower(var.code)}"
  resource_tags = {
    Task        = var.code
    env         = "dev"
    author      = "dannylu88"
  }
  rfc1918 = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]
}