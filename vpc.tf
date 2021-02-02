data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = join("-", [var.namespace, var.stage, var.name])
  cidr                 = var.cidr_block
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  azs                  = data.aws_availability_zones.available.names
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}
