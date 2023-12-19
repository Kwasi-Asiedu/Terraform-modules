variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "hostname_toggle" {
  type    = bool
  default = true
}

variable "avail_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}


variable "subnets" {
  type    = list(string)
  default = ["Web-public-subnet-1", "Web-public-subnet-2", "App-private-subnet-1", "App-private-subnet-2"]
}

variable "project-name" {
  type    = string
  default = "Cloudrock"
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "servers" {
  type    = list(string)
  default = ["server-1", "server-2", "server-3", "server-4"]
}


variable "security_group_ingress" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [{
    description = "Allow SSH"
    port        = 22
    },
    {
      description = "Allow HTTP"
      port        = 80
  }, ]
}

variable "security_group_egress" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [{
    description = "outbound traffic outlet"
    port        = 0
  }]
}

variable "database_security_group_ingress" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [{
    description = "Allow SSH"
    port        = 22
    },
    {
      description = "Allow HTTP"
      port        = 80
    },
    {
      description = "MySQL port"
      port        = 3306
  }]
}

variable "database_security_group_egress" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [{
    description = "outbound traffic outlet"
    port        = 0
  }]
}

variable "IGW_dest_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "NGW_dest_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ami" {
  type    = string
  default = "ami-0505148b3591e4c07"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "Cloudrock-key"
}

variable "db_name" {
  type    = string
  default = "cloudrockDB"
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.35"
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "alphabeta"
}

variable "allocated_storage" {
  type    = number
  default = 10
}

variable "parameter_group_name" {
  type    = string
  default = "default.mysql8.0"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_subnet_group_name" {
  type    = string
  default = "cloudrock_subnet_group"
}

/*variable "tenancy" {
  
}

variable "pub_sub_cidr1" {
  
}

variable "pub_sub_cidr2" {
  
}

variable "priv_app_sub_cidr1" {
  
}

variable "priv_app_sub_cidr2" {
  
}

variable "instance_type" {
  
}

variable "project_name" {
  
}*/