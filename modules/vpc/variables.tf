variable "cidr_block" {
  type        = string
  description = "main vpc cidr address"
  default     = "10.10.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "name for main vpc"
}
