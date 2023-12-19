# Configure Cloud Provider
provider "aws" {
  region = var.region
}


# VPC
resource "aws_vpc" "Tenacity-VPC" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.hostname_toggle


  tags = {
    Name = "${var.project-name}-VPC"
  }
}


# Data source to retrieve availability zones
data "aws_availability_zones" "AZs" {}


# Subnets
resource "aws_subnet" "Tenacity_subnets" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  count             = length(var.subnets)
  availability_zone = element(data.aws_availability_zones.AZs.names, count.index) 
  cidr_block        = var.subnet_cidr[count.index]

  tags = {
    Name = var.subnets[count.index]
  }
}


# Public route table
resource "aws_route_table" "Tenacity-public-route-table" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "${var.project-name}-pub-route-table"
  }
}


# Private route table
resource "aws_route_table" "Tenacity-private-route-table" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "${var.project-name}-priv-route-table"
  }
}


# First public route table association
resource "aws_route_table_association" "Tenacity-pub-route-association-1" {
  subnet_id      = aws_subnet.Tenacity_subnets[0].id
  route_table_id = aws_route_table.Tenacity-public-route-table.id
}


# Second public route table association
resource "aws_route_table_association" "Tenacity-pub-route-association-2" {
  subnet_id      = aws_subnet.Tenacity_subnets[1].id
  route_table_id = aws_route_table.Tenacity-public-route-table.id
}


# First private route table association
resource "aws_route_table_association" "Tenacity-priv-route-association-1" {
  subnet_id      = aws_subnet.Tenacity_subnets[2].id
  route_table_id = aws_route_table.Tenacity-private-route-table.id
}


# Second private route table association
resource "aws_route_table_association" "Tenacity-priv-route-association-2" {
  subnet_id      = aws_subnet.Tenacity_subnets[3].id
  route_table_id = aws_route_table.Tenacity-private-route-table.id
}


# Internet gateway
resource "aws_internet_gateway" "Tenacity-IGW" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "${var.project-name}-IGW"
  }
}


# Associating Internet gateway with the public route table
resource "aws_route" "Tenacity-IGW-association" {
  route_table_id         = aws_route_table.Tenacity-public-route-table.id
  destination_cidr_block = var.IGW_dest_cidr
  gateway_id             = aws_internet_gateway.Tenacity-IGW.id

}


# Allocation of Elastic IP
resource "aws_eip" "Tenacity-EIP" {
  # Chose not to use "depends_on" condition
}


# NAT Gateway
resource "aws_nat_gateway" "Tenacity-NGW" {
  allocation_id = aws_eip.Tenacity-EIP.id
  subnet_id     = aws_subnet.Tenacity_subnets[0].id

  tags = {
    Name = "${var.project-name}-NGW"
  }
}



# Associating NAT gateway with the private route table
resource "aws_route" "Tenacity-NGW-association" {
  route_table_id         = aws_route_table.Tenacity-private-route-table.id
  destination_cidr_block = var.NGW_dest_cidr
  gateway_id             = aws_nat_gateway.Tenacity-NGW.id
}


# EC2
resource "aws_instance" "Tenacity_server" {
  ami                         = var.ami # Ubuntu 22
  instance_type               = var.instance-type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.test-SG.id]
  subnet_id                   = aws_subnet.Tenacity_subnets[count.index].id
  associate_public_ip_address = true
  count                       = length(var.servers)


  tags = {
    Name = "Cloudrock-${var.servers[count.index]}"
  }
  depends_on = [aws_key_pair.Cloudrock-key]
}


# Key pair (public)
resource "aws_key_pair" "Cloudrock-key" {
  key_name   = "${var.project-name}-key"
  public_key = file("Cloudrock-key.pub")
}


# EC2 security group
resource "aws_security_group" "test-SG" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
    }
  }
  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      description = egress.value.description
      from_port = egress.value.port
      to_port = egress.value.port
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "-1"
    }
  }
  tags = {
    Name = "${var.project-name}-SG" 
  }

  depends_on = [ aws_vpc.Tenacity-VPC ]
}


# Creating subnet group for RDS
resource "aws_db_subnet_group" "tenacity_subgrp" {
  name       = var.db_subnet_group_name
  subnet_ids = [aws_subnet.Tenacity_subnets[2].id, aws_subnet.Tenacity_subnets[3].id]

  tags = {
    Name = "${var.project-name}-db_subnet_group"
  }
}


# RDS
resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.tenacity_subgrp.name
  vpc_security_group_ids = [aws_security_group.database-SG.id]
  

  depends_on = [ aws_vpc.Tenacity-VPC ]

  tags = {
    Name = "${var.project-name}-DB"
  }
}


# RDS security group
resource "aws_security_group" "database-SG" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  dynamic "ingress" {
    for_each = var.database_security_group_ingress
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "tcp"
    }
  }

  dynamic "egress" {
    for_each = var.database_security_group_egress
    content {
      description = egress.value.description
      from_port = egress.value.port
      to_port = egress.value.port
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "-1"
    }
  }
  
  depends_on = [ aws_security_group.test-SG]

  tags = {
    Name = "${var.project-name}-Database-SG"
  }
}