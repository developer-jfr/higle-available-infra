# all subnets in specific region
locals {
  default = flatten(data.aws_subnets.all_subnets.ids)
}