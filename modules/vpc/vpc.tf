variable "project_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}
