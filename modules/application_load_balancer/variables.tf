variable "vpc_id" {
  type        = string
  description = "ID for vpc"
}
variable "alb_name" {
  type        = string
  description = "name for Application load balancer"
}
variable "alb_subnet_id" {
  type        = list(string)
  description = "id for alb subnet"
}
variable "security_group_id" {
  type        = string
  description = "application loadbalancer security group id"
}
variable "health_check_path" {
  type        = string
  description = "Path for health check"
  default     = "/"
}

# variable "public_subnet_ids" {
#   type        = list(string)
#   description = "List of public subnet ids for NAT gateway"
# }

variable "load_balancer_type" {
  type        = string
  description = "lb type like application,network etc"
  default     = "application"
}
variable "target_group_type" {
  type        = string
  description = "the type for taget group"
  # default     = "instance" #instance,ip,lambda
}

variable "target_ids" {
  type        = list(string)
  description = "List of target ids"
}
variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}
