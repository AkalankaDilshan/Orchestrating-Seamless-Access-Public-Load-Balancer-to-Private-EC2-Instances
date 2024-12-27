resource "aws_lb" "application_load_balancer" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.alb_subnet_id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.alb_name
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
resource "aws_lb_target_group" "tg" {
  name        = var.alb_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  for_each         = toset(var.taget_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}