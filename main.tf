provider "aws" {
  region = var.region
}

module "main_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "Backend-VPC"
  cidr_block           = "11.10.0.0/16"
  availability_zones   = ["eu-north-1a", "eu-north-1b"]
  private_subnet_cidrs = ["11.10.3.0/24", "11.10.4.0/24"]
}
