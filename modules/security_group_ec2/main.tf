resource "aws_security_group" "server_sg" {
  name        = var.sg_name
  description = "allow ssg,HTTP,HTTPS traffic passing through NAT"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.sg_name
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  description       = ""
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.nat_gateway_eip
  security_group_id = aws_security_group.server_sg.id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  description       = "HTTP ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.nat_gateway_eip
  security_group_id = aws_security_group.server_sg.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  description       = "HTTP ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.nat_gateway_eip
  security_group_id = aws_security_group.server_sg.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
}
