variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

###########################################
# SECURITY GROUP FOR APPLICATION LOAD BALANCER
###########################################
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP/HTTPS inbound to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Enable HTTPS later if needed
  # ingress {
  #   description = "HTTPS"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

###########################################
# SECURITY GROUP FOR EC2 INSTANCES
###########################################
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow traffic only from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description       = "Allow HTTP from ALB"
    from_port         = 5000
    to_port           = 5000
    protocol          = "tcp"
    security_groups   = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

###########################################
# OUTPUTS
###########################################
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}
