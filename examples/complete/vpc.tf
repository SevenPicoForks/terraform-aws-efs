# ------------------------------------------------------------------------------
# Vpc
# ------------------------------------------------------------------------------
module "vpc" {
  source  = "SevenPico/vpc/aws"
  version = "3.0.0"

  ipv4_primary_cidr_block                   = "172.16.0.0/16"
  assign_generated_ipv6_cidr_block          = true
  ipv6_egress_only_internet_gateway_enabled = true

  context = module.context.self
}


# ------------------------------------------------------------------------------
# Vpc Subnet
# ------------------------------------------------------------------------------
module "subnets" {
  source  = "SevenPico/dynamic-subnets/aws"
  version = "3.1.2"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.context.self
}