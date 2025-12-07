variable "vpc_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "region" {
    type = string
}

resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)  # explained below
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${var.azs[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 100) # private range
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-private-${var.azs[count.index]}"
  }
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
