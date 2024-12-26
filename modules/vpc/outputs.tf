output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_name" {
  value = var.vpc_name
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id

}
output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}
output "nat_gateway_eip" {
  value = aws_nat_gateway.nat_gateway.public_ip[*]
}
