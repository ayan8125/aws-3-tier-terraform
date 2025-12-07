variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1" 
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "three-tier-app"
}


variable "ami_id" {
  description = "Name prefix for all resources"
  type        = string
  default     = "ami-0ecb62995f68bb549"
}

variable "instances_types" {
  description = "Name prefix for all resources"
  type        = string
  default     = "t2.micro"
}
