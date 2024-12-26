variable "cidr_block" {
  type        = string
  description = "main vpc cidr address"
  default     = "10.10.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "name for main vpc"
}

variable "availability_zones" {
  type        = list(string)
  description = "availability zone list"
}

# variable "public_subnet_cidrs" {
#   type        = list(string)
#   description = "cidr values for public subnet"
# }

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "cidr values for ptivate subnet"
}
