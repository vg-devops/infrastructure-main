provider "aws" {
  region  = var.region
}

terraform {
  #This is set to a major version, so changes beyond 1.9 cannot be used when untested.
  required_version = "~> v1.9.7"

  backend "s3" {
    bucket = "terraform-states-361769587713" # -{ACCOUNT_ID_PLACEHOLDER}
    key    = "network/development_environment.tfstate"
    region = "eu-west-2"
    
    # role_arn     = "arn:aws:iam::{ACCOUNT_ID_PLACEHOLDER}:role/terraform"
    # session_name = "terraform"
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}