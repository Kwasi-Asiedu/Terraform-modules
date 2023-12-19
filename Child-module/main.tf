provider "aws" {
  region = var.provider_region
}

module "VPC" {
  source               = "../Parent-module"
  vpc_cidr             = var.vpc_cidr
  instance_tenancy     = var.tenancy
  hostname_toggle      = var.hostname_toggle
  subnets              = [var.subnets[0], var.subnets[1], var.subnets[2], var.subnets[3]]
  avail_zones          = [var.avail_zones[0], var.avail_zones[1], var.avail_zones[2], var.avail_zones[0]]
  subnet_cidr          = [var.subnet_cidr[0], var.subnet_cidr[1], var.subnet_cidr[2], var.subnet_cidr[3]]
  servers              = [var.servers[0], var.servers[1], var.servers[2], var.servers[3]]
  db_subnet_group_name = var.db_subnet_group_name

}