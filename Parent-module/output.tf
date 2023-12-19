output "vpc_id" {
  value = aws_vpc.Tenacity-VPC.id
}

output "subnet-1-id" {
  value = aws_subnet.Tenacity_subnets[0].id
}