provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"
  name = "Zoominfo"
  cidr = "10.0.0.0/16"
  azs  = ["us-west-2a","us-west-2b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24"]
  enable_ipv6 = true
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
   Name = "Zoominfo"
  }
  vpc_tags = {
   Name = "Zoominfo"
  }
}

