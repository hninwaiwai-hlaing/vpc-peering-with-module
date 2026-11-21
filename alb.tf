locals {
  instance_ids = {
    instance_1 = module.customer_profile_instance_1.id
    instance_2 = module.customer_profile_instance_2.id
    instance_3 = module.customer_profile_instance_3.id
  }
  account_instance_ids = {
    instance_1 = module.account_instance_1.id
    instance_2 = module.account_instance_2.id
    instance_3 = module.account_instance_3.id
  }
  statement_instance_ids = {
    instance_1 = module.statement_instance_1.id
    instance_2 = module.statement_instance_2.id
    instance_3 = module.statement_instance_3.id
  }
}
################################################################################
# customer_profile_alb
################################################################################
module "customer_profile_alb" {
  source = "terraform-aws-modules/alb/aws"
  # version = "~> 9.0"

  providers = {
    aws = aws.tokyo
  }

  name                       = var.customer_profile_alb_name
  load_balancer_type         = var.customer_profile_alb_load_balancer_type
  internal                   = var.customer_profile_alb_internal
  vpc_id                     = module.customer_profile_vpc.vpc_id
  subnets                    = module.customer_profile_vpc.public_subnets
  enable_deletion_protection = false

  security_group_name          = var.customer_profile_alb_security_group_name
  security_group_description   = var.customer_profile_alb_security_group_description
  security_group_ingress_rules = var.customer_profile_alb_security_group_ingress_rules

  security_group_egress_rules = {
    to_customer_profile_instances = {
      description = "ALB to customer profile instances"
      from_port   = 9091
      to_port     = 9091
      ip_protocol = "tcp"
      cidr_ipv4   = module.customer_profile_vpc.vpc_cidr_block
    }
  }

  # target group
  target_groups = var.customer_profile_alb_target_groups

  # attach all three instances
  additional_target_group_attachments = {
    for key, att in coalesce(var.customer_profile_alb_additional_target_group_attachments, {}) : key => merge(att, {
      target_id = lookup(local.instance_ids, att.target_id, att.target_id)
    })
  }

  # listeners
  listeners = var.customer_profile_alb_listeners
}


################################################################################
# account_alb
################################################################################
module "account_alb" {
  source = "terraform-aws-modules/alb/aws"
  # version = "~> 9.0"

  providers = {
    aws = aws.osaka
  }

  name                       = var.account_alb_name
  load_balancer_type         = var.account_alb_load_balancer_type
  internal                   = var.account_alb_internal
  vpc_id                     = module.account_vpc.vpc_id
  subnets                    = module.account_vpc.private_subnets
  enable_deletion_protection = false

  security_group_name        = var.account_alb_security_group_name
  security_group_description = var.account_alb_security_group_description

  security_group_ingress_rules = {
    allow_customer_profile_instance = {
      description = "Allow traffic from customer_profile_instances"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = module.customer_profile_vpc.vpc_cidr_block
    }
  }
  security_group_egress_rules = {
    to_account_instances = {
      description                  = "ALB to account instances"
      ip_protocol                  = "tcp"
      from_port                    = 9092
      to_port                      = 9092
      referenced_security_group_id = module.account_instance_1.security_group_id
      # cidr_ipv4   = module.account_vpc.vpc_cidr_block
    }
  }

  # target group
  target_groups = var.account_alb_target_groups

  # attach all three instances
  additional_target_group_attachments = {
    for key, att in coalesce(var.account_alb_additional_target_group_attachments, {}) : key => merge(att, {
      target_id = lookup(local.account_instance_ids, att.target_id, att.target_id)
    })
  }

  # listeners
  listeners = var.account_alb_listeners
}

################################################################################
# statement_alb
################################################################################
module "statement_alb" {
  source = "terraform-aws-modules/alb/aws"
  # version = "~> 9.0"

  providers = {
    aws = aws.singapore
  }

  name                       = var.statement_alb_name
  load_balancer_type         = var.statement_alb_load_balancer_type
  internal                   = var.statement_alb_internal
  vpc_id                     = module.statement_vpc.vpc_id
  subnets                    = module.statement_vpc.private_subnets
  enable_deletion_protection = false

  security_group_name        = var.statement_alb_security_group_name
  security_group_description = var.statement_alb_security_group_description

  security_group_ingress_rules = {
    allow_account_instance = {
      description = "Allow traffic from account_instance"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = module.account_vpc.vpc_cidr_block
    }
  }
  security_group_egress_rules = {
    to_statement_instances = {
      description                  = "ALB to statement_instance"
      ip_protocol                  = "tcp"
      from_port                    = 9093
      to_port                      = 9093
      referenced_security_group_id = module.statement_instance_1.security_group_id
    }
  }

  # target group
  target_groups = var.statement_alb_target_groups

  # attach all three instances
  additional_target_group_attachments = {
    for key, att in coalesce(var.statement_alb_additional_target_group_attachments, {}) : key => merge(att, {
      target_id = lookup(local.statement_instance_ids, att.target_id, att.target_id)
    })
  }

  # listeners
  listeners = var.statement_alb_listeners
}
output "customer_profile_alb_dns" {
  value = module.customer_profile_alb.dns_name
}
output "customer_profile_vpc_cidr_block" {
  value = module.customer_profile_vpc.vpc_cidr_block
}
