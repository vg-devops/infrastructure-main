###### This file contains useful outputs for VPC and related resources #######

output "eks_vpc_id" {
  description = "The ID of the main VPC to be used for EKS cluster"
  value       = module.vpc_application.vpc_id
}

output "generic_public_subnets" {
  description = "List of IDs of public subnets: by 256 hosts"
  value       = module.vpc_application.public_subnets
}

output "ec2_nodes_private_subnets" {
  description = "List of IDs of private subnets to be used for EKS EC2 nodes: by 4096 hosts"
  value       = module.vpc_application.private_subnets
}

output "fargate_nodes_private_subnets" {
  description = "List of IDs of private subnets to be used for EKS Fargate nodes: by 4096 hosts"
  value       = module.vpc_application.intra_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets: by 256 hosts"
  value       = module.vpc_application.database_subnets
}

output "nat_public_ip" {
  description = "Public Elastic IP of AWS NAT Gateway (only one created)"
  value       = module.vpc_application.nat_public_ips[0]
}

output "vpc_id" {
  description = "ID of Application VPC created"
  value       = module.vpc_application.vpc_id
}

output "vpc_arn" {
  description = "Amazon Resource Name (ARN) of Application VPC created"
  value       = module.vpc_application.vpc_arn
}

output "vpc_cidr" {
  description = "Network CIDR of Application VPC created"
  value       = module.vpc_application.vpc_cidr_block
}

output "ecr_user_arn" {
  description = "aws res name for ecr-user"
  value       = aws_iam_user.ecr_user.arn
}