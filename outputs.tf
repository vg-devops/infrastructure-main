###### This file contains useful outputs for VPC and related resources #######

output "eks_vpc_id" {
  description = "The ID of the main VPC to be used for EKS cluster"
  value       = module.vpc_application.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_application.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets to be used for EKS EC2 nodes: 4096 hosts"
  value       = module.vpc_application.private_subnets
}

output "intra_subnets" {
  description = "List of IDs of private subnets to be used for EKS Fargate nodes: 4096 hosts"
  value       = module.vpc_application.intra_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets: 256 hosts"
  value       = module.vpc_application.database_subnets
}

output "nat_public_ip" {
  description = "Public Elastic IP of AWS NAT Gateway (only one created)"
  value       = module.vpc_application.nat_public_ips[0]
}