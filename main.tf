module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  cidr_block   = "10.0.0.0/16"
}


module "subnets" {
    source = "./modules/subnets"
    vpc_id = module.vpc.vpc_id
    project_name = var.project_name
    region = var.aws_region
    
    azs = [
        "us-east-1a",
        "us-east-1b"
    ]

}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
    source = "./modules/alb"
    vpc_id = module.vpc.vpc_id
    project_name = var.project_name
    alb_security_group_id = module.security.alb_sg_id
    public_subnet_ids = module.subnets.public_subnet_ids
}

module "asg" {
  source = "./modules/asg"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.subnets.private_subnet_ids
  ec2_security_group_id = module.security.ec2_sg_id
  target_group_arn      = module.alb.target_group_arn
  instances_type = var.instances_types
  ami_id = var.ami_id
}


output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnet_ids
}

output "private_subnets" {
  value = module.subnets.private_subnet_ids
}

output "interner_gateway" {
    value = module.subnets.interner_gateway_id
}

output "aws_nat_gateway" {
    value = module.subnets.aws_nat_gateway_ids
}


output "nat_elastic_ip" {
    value = module.subnets.aws_eip_ids
}


output "alb_dns" {
  value = module.alb.alb_dns_name
}
