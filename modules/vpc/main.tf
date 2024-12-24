resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private subnet ${count.index + 1}"
  }
}

# VPC Route Table Section
resource "aws_eip" "elastic_IP_address" {
  count  = 2
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-vpc-nat_gateway-EIP"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  count         = 2
  allocation_id = aws_eip.elastic_IP_address[count.index].id
  subnet_id     = element(aws_subnet.private_subnet[*].id, 0)
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route" "private_route" {
  count                  = 2
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "private_RT_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].index
  route_table_id = aws_route.private_route.id
}

# Network ACL Section
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_network_acl" "private_ACL" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-NACL"
  }
}

resource "aws_network_acl_rule" "public_ssh_inbound" {
  network_acl_id = aws_network_acl.private_ACL.id
  rule_number    = 100
  rule_action    = "allow"
  protocol       = "6"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_ssh_outbound" {
  network_acl_id = aws_network_acl.private_ACL.id
  rule_number    = 100
  rule_action    = "allow"
  protocol       = "6"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_all_outbound" {
  network_acl_id = aws_network_acl.private_ACL.id
  rule_number    = 200
  rule_action    = "allow"
  protocol       = "-1"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_deny_all_inbound" {
  network_acl_id = aws_network_acl.private_ACL.id
  rule_number    = 300
  rule_action    = "deny"
  protocol       = "-1"
  egress         = false
  cidr_block     = "0.0.0.0/0"
}
