variable "provider_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "Cloudrock"
}

variable "vpc_cidr" {
  type    = string
  default = "120.0.0.0/16"
}

variable "tenancy" {
  type    = string
  default = "default"
}

variable "subnets" {
  type    = list(string)
  default = ["test-sub-1", "test-sub-2", "test-sub-3", "test-sub-3"]
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["120.0.0.0/24", "120.0.1.0/24", "120.0.2.0/24", "120.0.3.0/24"]
}

variable "servers" {
  type    = list(string)
  default = ["EC2-1", "EC2-2", "EC2-3", "EC2-4"]
}

variable "avail_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "db_subnet_group_name" {
  type    = string
  default = "module-sub-db"
}

variable "hostname_toggle" {
  type    = bool
  default = true
}

