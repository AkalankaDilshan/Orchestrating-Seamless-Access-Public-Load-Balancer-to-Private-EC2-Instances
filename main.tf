provider "aws" {
  region = var.region
}

module "main_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "Backend-VPC"
  cidr_block           = "11.10.0.0/16"
  availability_zones   = ["eu-north-1a", "eu-north-1b"]
  public_subnet_cidrs  = ["11.10.1.0/24", "11.10.2.0/24"]
  private_subnet_cidrs = ["11.10.3.0/24", "11.10.4.0/24"]
}

module "ec2_security_group" {
  source          = "./modules/security_group_ec2"
  sg_name         = "server_sg"
  vpc_id          = module.main_vpc.vpc_id
  nat_gateway_eip = [flatten([module.main_vpc.nat_gateway_eip])]
}
