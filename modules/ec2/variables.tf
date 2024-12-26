variable "instance_name" {
  type        = string
  description = "Name for the EC2 instance "
}

variable "instance_type" {
  type        = string
  description = "type for the EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "subnet id for EC2 instace"
}

variable "vpc_security_group_id" {
  type        = string
  description = "security group id"
}
variable "ebs_volume_type" {
  type        = string
  description = "type of instance value"
  default     = "gp2"
}

variable "ebs_volume_size" {
  type        = number
  description = "size of instance value"
  default     = 8
}

variable "key_pair_name" {
  type        = string
  description = "name for ec2 instance key-pair"
}

variable "depends_on" {
  type        = list(any)
  description = "List of resources that need to be created before this one."
  # default     = [aws_key_pair.ssh, aws_security_group.securitygroup]
}
