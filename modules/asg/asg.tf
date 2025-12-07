################################################
# VARIABLES
################################################
variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ami_id" {
    type = string
}

variable "instances_type" {
    type = string
}


################################################
# LAUNCH TEMPLATE
################################################
resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-lt"

  image_id      = var.ami_id 
  instance_type = var.instances_type
  
  vpc_security_group_ids = [var.ec2_security_group_id]

  user_data = base64encode(file("${path.module}/userdata.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-instance"
    }
  }
}

################################################
# AUTO SCALING GROUP
################################################
resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-asg"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key = "Name"
    value = "${var.project_name}-asg"
    propagate_at_launch = true
  }
}

################################################
# OUTPUTS
################################################
output "asg_name" {
  value = aws_autoscaling_group.app.name
}
