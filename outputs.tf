output "ec2_key_pair" {
  value = module.key_pair.key_pair_name
}

# output "alb_dns_name" {
#   value = module.application_load_balancer.alb_dns_name
# }
