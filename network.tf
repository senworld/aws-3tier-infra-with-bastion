########################
#vpc_a declaration
########################
module "vpc_a" {
  source = "./Modules/vpc"
  cidr_range = "192.168.0.0/16"
  tags_value = merge(var.root_tags,local.tags)
}

module "internet_gateway_a"{
  source = "./Modules/internet_gateway"
  vpc_id = module.vpc_a.id
  tags_value = merge(var.root_tags,local.tags)
}

################################
#Route table declaration
################################

module "route_table_web" {
  source = "./Modules/route_table"
  cidr_range = module.vpc_a.cidr_block
  vpc_id = module.vpc_a.id
  route = [
    {
      cidr_block="0.0.0.0/0"
      gateway_id=module.internet_gateway_a.id
    }
  ]
  tags_value = merge(var.web_tags,local.tags)
}

module "route_table_app" {
  source = "./Modules/route_table"
  cidr_range = module.vpc_a.cidr_block
  vpc_id = module.vpc_a.id
  route = []
  tags_value = merge(var.app_tags,local.tags)
}

module "route_table_db" {
  source = "./Modules/route_table"
  cidr_range = module.vpc_a.cidr_block
  vpc_id = module.vpc_a.id
  route = []
  tags_value = merge(var.db_tags,local.tags)
}

################################
#Web subnet declaration
################################

module "subnet_web" {
  source = "./Modules/subnet"
  vpc_id = module.vpc_a.id
  cidr_range = var.subnet_web[count.index]["cidr_range"]
  subnet_az = var.subnet_web[count.index]["subnet_az"]
  tags_value = merge(var.subnet_web[count.index]["tags_value"],local.tags)
  is_public = var.subnet_web[count.index]["is_public"]
  count = length(var.subnet_web)
}

module "rt_subnet_web_link" {
  source = "./Modules/rt_subnet_link"
  subnet_id = module.subnet_web[count.index].id
  route_table_id = module.route_table_web.id
  count = length(var.subnet_web)
}

################################
#Application subnet declaration
################################

module "subnet_app" {
  source = "./Modules/subnet"
  vpc_id = module.vpc_a.id
  cidr_range = var.subnet_app[count.index]["cidr_range"]
  subnet_az = var.subnet_app[count.index]["subnet_az"]
  tags_value = merge(var.subnet_app[count.index]["tags_value"],local.tags)
  count = length(var.subnet_app)
}

module "rt_subnet_app_link" {
  source = "./Modules/rt_subnet_link"
  subnet_id = module.subnet_app[count.index].id
  route_table_id = module.route_table_app.id
  count = length(var.subnet_app)
}

################################
#Database subnet declaration
################################

module "subnet_db" {
  source = "./Modules/subnet"
  vpc_id = module.vpc_a.id
  cidr_range = var.subnet_db[count.index]["cidr_range"]
  subnet_az = var.subnet_db[count.index]["subnet_az"]
  tags_value = merge(var.subnet_db[count.index]["tags_value"],local.tags)
  count = length(var.subnet_db)
}

module "rt_subnet_db_link" {
  source = "./Modules/rt_subnet_link"
  subnet_id = module.subnet_db[count.index].id
  route_table_id = module.route_table_db.id
  count = length(var.subnet_db)
}