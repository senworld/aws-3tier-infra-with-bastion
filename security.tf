################################
#Webtier nacl_a declaration
################################
module "nacl_root" {
  source = "./Modules/nacl"
  vpc_id = module.vpc_main.id
  subnet_ids = [for o in module.subnet_main: o.id]
  egress_rule = jsondecode(jsonencode(var.nacl_egress_rules))
  ingress_rule = jsondecode(jsonencode(var.nacl_ingress_rules))
  tags_value = merge(var.root_tags,local.tags)
}
###################################
#Webtier Security Group declaration
###################################
module "security_group_web_a" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_main.id
  sg_name = "security_group_web_a"
  ingress_rule = jsondecode(jsonencode(var.web_sg_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.web_sg_egress_rules))
  tags_value = merge(var.web_tags,local.tags)
}

###################################
#Apptier Security Group declaration
###################################
module "security_group_app_a" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_main.id
  sg_name = "security_group_app_a"
  ingress_rule = jsondecode(jsonencode(var.app_sg_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.app_sg_egress_rules))
  tags_value = merge(var.app_tags,local.tags)
}

###################################
#DBtier Security Group declaration
###################################
module "security_group_db_a" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_main.id
  sg_name = "security_group_db_a"
  ingress_rule = jsondecode(jsonencode(var.db_sg_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.db_sg_egress_rules))
  tags_value = merge(var.db_tags,local.tags)
}

###################################
#automation Security Group declaration
###################################
module "security_group_automation" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_main.id
  sg_name = "security_group_automation"
  ingress_rule = jsondecode(jsonencode(var.automation_sg_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.automation_sg_egress_rules))
  tags_value = merge(var.automation_tags,local.tags)
}

#================================================X================================================#

################################
#Bastion nacl_b declaration
################################
module "nacl_bastion" {
  source = "./Modules/nacl"
  vpc_id = module.vpc_bastion.id
  subnet_ids = [module.subnet_bastion["bastion"].id]
  egress_rule = jsondecode(jsonencode(var.nacl_egress_rules))
  ingress_rule = jsondecode(jsonencode(var.nacl_ingress_rules))
  tags_value = merge(var.bastion_tags,local.tags)
}

###################################
#Bastion Security Group declaration
###################################
module "security_group_bastion_a" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_bastion.id
  sg_name = "security_group_bastion_a"
  ingress_rule = jsondecode(jsonencode(var.bastion_sg_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.bastion_sg_egress_rules))
  tags_value = merge(var.bastion_tags,local.tags)
}

#================================================X================================================#

#########################################
#LoadBalancer Security Group declaration
#########################################

module "security_group_alb_a" {
  source = "./Modules/security_group"
  vpc_id = module.vpc_main.id
  sg_name = "security_group_alb_a"
  ingress_rule = jsondecode(jsonencode(var.alb_ingress_rules))
  egress_rule = jsondecode(jsonencode(var.alb_egress_rules))
  tags_value = merge({ Name="${var.web_tags["Name"]}-sg-alb"},local.tags)
}