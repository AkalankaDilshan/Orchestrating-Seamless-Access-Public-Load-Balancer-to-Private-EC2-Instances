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
  nat_gateway_eip = flatten([module.main_vpc.nat_gateway_eip])
}

module "application_load_balancer_sg" {
  source = "./modules/security_group_alb"
  vpc_id = module.main_vpc.vpc_id
}

module "application_load_balancer" {
  source            = "./modules/application_load_balancer"
  alb_name          = "app-load-balancer"
  vpc_id            = module.main_vpc.vpc_id
  public_subnet_ids = flatten([module.main_vpc.public_subnet_id])
  taget_ids         = flatten([module.main_vpc.nat_gateway_eip])
  security_group_id = module.application_load_balancer_sg.alb_security_group_id
  alb_subnet_id     = module.main_vpc.public_subnet_id[0]
}
module "key_pair" {
  source = "./modules/key-pair"
}

module "backend_instance_blue" {
  source                = "./modules/ec2"
  instance_name         = "blue_instance"
  instance_type         = "t3.micro"
  subnet_id             = module.main_vpc.private_subnet_id[0]
  vpc_security_group_id = module.ec2_security_group.ec2_sg_id
  ebs_volume_size       = 8
  ebs_volume_type       = "gp2"
  key_pair_name         = module.key_pair.key_pair_name
  depends_on            = [module.key_pair, module.ec2_security_group]
}

module "backend_instance_green" {
  source                = "./modules/ec2"
  instance_name         = "green_instance"
  instance_type         = "t3.micro"
  subnet_id             = module.main_vpc.private_subnet_id[1]
  vpc_security_group_id = module.ec2_security_group.ec2_sg_id
  ebs_volume_size       = 8
  ebs_volume_type       = "gp2"
  key_pair_name         = module.key_pair.key_pair_name
  depends_on            = [module.key_pair, module.ec2_security_group]
}
