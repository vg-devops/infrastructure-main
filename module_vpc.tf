module "vpc_application" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13.0"

  name = "eks-fargate-vpc"
  cidr = "10.11.0.0/16"  # Total addresses: 65536

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  
  # Public subnets (smaller)
  public_subnets  = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]  # 256 hosts each
  
  # Private subnets for EKS (larger)
  private_subnets = ["10.11.16.0/20", "10.11.32.0/20", "10.11.48.0/20"]  # 4096 hosts each
  
  # Fargate subnets (larger)
  intra_subnets   = ["10.11.64.0/20", "10.11.80.0/20", "10.11.96.0/20"]  # 4096 hosts each
  
  # RDS subnets (smaller)
  database_subnets = ["10.11.112.0/24", "10.11.113.0/24", "10.11.114.0/24"]  # 256 hosts each
  
  # possible spare network space for future subnets left as 
  # ["10.11.115.0/24", "10.11.116.0/24", "10.11.117.0/24"]  # 256 hosts each

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true
  
  create_multiple_intra_route_tables = true

  intra_route_table_tags = {
    Name = "eks-fargate-intra-route-table"
    Environment = "development"
    Project     = "exa-devops-assessment"
  }

  tags = {
    Environment = "development"
    Project     = "exa-devops-assessment"
  }
}

resource "aws_route" "intra_subnets_extra_rt_destination_to_nat_gw" {
  count                  = length(module.vpc_application.intra_route_table_ids)
  route_table_id         = module.vpc_application.intra_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.vpc_application.natgw_ids[0]

  depends_on = [module.vpc_application]
}