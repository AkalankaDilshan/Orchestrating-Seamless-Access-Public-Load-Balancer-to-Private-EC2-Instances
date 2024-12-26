variable "sg_name" {
  type        = string
  description = "name for the security group for ec2"
}

variable "vpc_id" {
  type        = string
  description = "ID for main VPC"
}

variable "nat_gateway_eip" {
  type        = list(string)
  description = "NAT Gateway Elastic IP addresses"
}
