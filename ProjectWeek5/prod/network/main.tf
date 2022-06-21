module "globalvars" {
  source = "../../../modules/globalvars"
}
locals {
  prefix       = module.globalvars.prefix
  name_prefix  = "${module.globalvars.prefix}-${var.env}"
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
}

# Module to deploy basic networking 
module "vpc-devrp" {
  source = "../../../modules/aws_network"
  #source              = "git@github.com:igeiman/aws_network.git"
  env                     = var.env
  vpc_cidr                = var.vpc_cidr
  private_cidr_blocks     = var.private_subnet_cidrs
  public_cidr_blocks      = var.public_subnet_cidrs
  prefix                  = local.prefix
  default_tags            = local.default_tags
  enable_internet_gateway = false
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
}