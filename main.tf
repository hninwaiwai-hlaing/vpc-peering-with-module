module "customer_profile_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3" # pin to exact version - HashiCorp Recommendation
  #   version = "~> 6.7.1" # >= 6.7.1, < 6.8.0 - accept patch releases within the same minior
  #   version = "~> 6.7" # >= 6.7.0, < 7.0.0 - accept minor and patch releases within the major version
  #   version = ">= 6.7.1" # Any later version, including new majors

  providers = {
    aws = aws.tokyo
  }

  name = var.customer_profile_vpc_name
  cidr = var.customer_profile_vpc_cidr
  azs  = var.customer_profile_vpc_azs

  public_subnets = var.customer_profile_vpc_public_subnets

  private_subnets    = var.customer_profile_vpc_private_subnets
  enable_nat_gateway = var.customer_profile_vpc_enable_nat_gateway
  single_nat_gateway = var.customer_profile_vpc_single_nat_gateway
}

module "account_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3" # pin to exact version - HashiCorp Recommendation
  #   version = "~> 6.7.1" # >= 6.7.1, < 6.8.0 - accept patch releases within the same minior
  #   version = "~> 6.7" # >= 6.7.0, < 7.0.0 - accept minor and patch releases within the major version
  #   version = ">= 6.7.1" # Any later version, including new majors

  providers = {
    aws = aws.osaka
  }

  name = var.account_vpc_name
  cidr = var.account_vpc_cidr
  azs  = var.account_vpc_azs

  private_subnets = var.account_vpc_private_subnets
}

module "statement_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3" # pin to exact version - HashiCorp Recommendation
  #   version = "~> 6.7.1" # >= 6.7.1, < 6.8.0 - accept patch releases within the same minior
  #   version = "~> 6.7" # >= 6.7.0, < 7.0.0 - accept minor and patch releases within the major version
  #   version = ">= 6.7.1" # Any later version, including new majors

  providers = {
    aws = aws.singapore
  }

  name = var.statement_vpc_name
  cidr = var.statement_vpc_cidr
  azs  = var.statement_vpc_azs

  private_subnets = var.statement_vpc_private_subnets
}