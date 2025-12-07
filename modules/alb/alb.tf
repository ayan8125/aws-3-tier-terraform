################################################
# VARIABLES
################################################
variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

################################################
# APPLICATION LOAD BALANCER
################################################
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

################################################
# TARGET GROUP (EC2 INSTANCES ON PORT 5000)
################################################
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10

  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

################################################
# LISTENER FOR PORT 80
################################################
resource "aws_lb_listener" "http" {

    depends_on = [
        aws_lb_target_group.app
    ]

  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}



################################################
# OUTPUTS
################################################
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
