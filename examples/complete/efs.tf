# ------------------------------------------------------------------------------
# EFS
# ------------------------------------------------------------------------------
module "efs" {
  source = "../../"

  region  = var.region
  vpc_id  = module.vpc.vpc_id
  subnets = module.subnets.private_subnet_ids

  access_points = {
    "data" = {
      posix_user = {
        gid            = "1001"
        uid            = "5000"
        secondary_gids = "1002,1003"
      }
      creation_info = {
        gid         = "1001"
        uid         = "5000"
        permissions = "0755"
      }
    }
    "data2" = {
      posix_user = {
        gid            = "2001"
        uid            = "6000"
        secondary_gids = null
      }
      creation_info = {
        gid         = "123"
        uid         = "222"
        permissions = "0555"
      }
    }
  }

  additional_security_group_rules = [
    {
      type                     = "ingress"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      cidr_blocks              = []
      source_security_group_id = module.vpc.vpc_default_security_group_id
      description              = "Allow ingress traffic to EFS from trusted Security Groups"
    }
  ]

  transition_to_ia = ["AFTER_7_DAYS"]

  security_group_create_before_destroy = false

  context = module.context.self
}
