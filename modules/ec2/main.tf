data "aws_ami" "latest_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "server_instance" {
  ami                     = data.aws_ami.latest_ami.id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [var.vpc_security_group_id]
  user_data               = templatefile("${path.module}/init-script.sh", {})
  disable_api_termination = false
  ebs_optimized           = false
  root_block_device {
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    encrypted   = true
  }

  key_name = var.key_pair_name

  # depends_on = var.depends_on
  tags = {
    Name = var.instance_name
  }
}
