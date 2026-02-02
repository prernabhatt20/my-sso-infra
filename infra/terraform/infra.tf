# Calling locals of config module
locals {
  configs      = nonsensitive(module.config.config_env) # Retrieve configurations from the config module
  default_tags = module.config.default_tags
}

# Module for configuring common settings
module "config" {
  source                   = "./modules/config"
  enable_config_secrets    = true
  org_name                 = lookup(local.configs, "org_name")
  app_name                 = lookup(local.configs, "app_name")
  aws-migration-project-id = lookup(local.configs, "aws-migration-project-id")
  division                 = lookup(local.configs, "division")
  department               = lookup(local.configs, "department")
  technicalContact         = lookup(local.configs, "technicalContact")
  # sg_comman                = module.security_group.aws_sg_id["sg-comman"]
  # efs_id                   = module.efs.aws_efs_file_id
}

# Module for calling ecs-cluster module
module "ecs-cluster" {
  source           = "./modules/ecs-cluster"
  org_name         = lookup(local.configs, "org_name")
  app_name         = lookup(local.configs, "app_name")
  env              = terraform.workspace
  default_tags     = local.default_tags
  map_migrated_tag = lookup(local.configs, "map_migrated_tag")
}


#Module for Security Group for ALB
module "security_group" {
  source               = "./modules/security-group"
  aws_sg_configuration = lookup(local.configs, "aws_sg_configuration")
  app_name             = lookup(local.configs, "app_name")
  org_name             = lookup(local.configs, "org_name")
  env                  = terraform.workspace
  service_name         = lookup(local.configs, "service_name")
  default_tags         = local.default_tags
  aws_vpc_id           = lookup(local.configs, "aws_vpc_id")
  map_migrated_tag     = lookup(local.configs, "map_migrated_tag")
}
module "ecr" {

  source           = "./modules/ecr"
  app_name         = lookup(local.configs, "app_name")
  org_name         = lookup(local.configs, "org_name")
  env              = terraform.workspace
  service_name     = lookup(local.configs, "service_name")
  default_tags     = local.default_tags
  map_migrated_tag = lookup(local.configs, "map_migrated_tag")
}
