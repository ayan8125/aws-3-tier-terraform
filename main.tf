module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  cidr_block   = "10.0.0.0/16"
}
