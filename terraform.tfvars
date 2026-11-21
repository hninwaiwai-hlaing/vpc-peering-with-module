################################################################################
# customer_profile_vpc
################################################################################

customer_profile_vpc_name   = "customer_profile_vpc"
customer_profile_vpc_cidr   = "10.0.0.0/16"
customer_profile_vpc_region = "ap-northeast-1"
customer_profile_vpc_azs = [
  "ap-northeast-1a",
  "ap-northeast-1c",
  "ap-northeast-1d"
]

customer_profile_vpc_public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24",
]

customer_profile_vpc_private_subnets = [
  "10.0.201.0/24",
  "10.0.202.0/24",
  "10.0.203.0/24",
]
customer_profile_vpc_enable_nat_gateway = true
customer_profile_vpc_single_nat_gateway = true

################################################################################
# account_vpc
################################################################################
account_vpc_name   = "account_vpc"
account_vpc_cidr   = "10.2.0.0/16"
account_vpc_region = "ap-northeast-3"
account_vpc_azs = [
  "ap-northeast-3a",
  "ap-northeast-3b",
  "ap-northeast-3c"
]

account_vpc_private_subnets = [
  "10.2.201.0/24",
  "10.2.202.0/24",
  "10.2.203.0/24",
]
################################################################################
# statement_vpc
################################################################################
statement_vpc_name   = "statement_vpc"
statement_vpc_cidr   = "10.3.0.0/16"
statement_vpc_region = "ap-southeast-1"
statement_vpc_azs = [
  "ap-southeast-1a",
  "ap-southeast-1b",
  "ap-southeast-1c"
]

statement_vpc_private_subnets = [
  "10.3.201.0/24",
  "10.3.202.0/24",
  "10.3.203.0/24",
]

################################################################################
# jump_host
################################################################################
jump_host_instance_name                        = "jump_host_instance"
jump_host_instance_type                        = "t3.micro"
jump_host_instance_associate_public_ip_address = true
jump_host_instance_key_name                    = "jump-host-keypair"

################################################################################
# jump_host_instance_security_group
################################################################################
jump_host_instance_security_group_name = "jump_host_sgp"

jump_host_instance_security_group_ingress_rules = {
  allow_all_ipv4 = {
    cidr_ipv4   = "0.0.0.0/0"
    description = "Allow all inbound IPv4 traffic"
    ip_protocol = "-1"
  }
}
# jump_host_instance_security_group_egress_rules = {
#   allow_all_ipv4 = {
#     cidr_ipv4   = "0.0.0.0/0"
#     description = "Allow all outbound IPv4 traffic"
#     ip_protocol = "-1"
#   }

#   to_private_db = {
#     referenced_security_group_id = "sg-0123456789abcdef0"
#     description                  = "Allow PostgreSQL access to DB security group"
#     from_port                    = 5432
#     to_port                      = 5432
#     ip_protocol                  = "tcp"
#   }
# }

################################################################################
# customer_profile_instance_security_group
################################################################################
customer_profile_instance_security_group_name = "customer_profile_instance_sgp"
customer_profile_instance_security_group_ingress_rules = {
  allow_ssh_jump_host = {
    description = "Allow SSH from jump_host_instance"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
  }
  instance_from_alb = {
    description                  = "App port from ALB"
    from_port                    = 9091
    to_port                      = 9091
    ip_protocol                  = "tcp"
    referenced_security_group_id = null
  }
}

################################################################################
# customer_profile_instance_1
################################################################################
customer_profile_instance_1_name                        = "customer_profile_instance_1"
customer_profile_instance_1_type                        = "t3.micro"
customer_profile_instance_1_associate_public_ip_address = false
customer_profile_instance_1_key_name                    = "customer_profile_key_pair"

################################################################################
# customer_profile_instance_2
################################################################################
customer_profile_instance_2_name                        = "customer_profile_instance_2"
customer_profile_instance_2_type                        = "t3.micro"
customer_profile_instance_2_associate_public_ip_address = false
customer_profile_instance_2_key_name                    = "customer_profile_key_pair"

################################################################################
# customer_profile_instance_3
################################################################################
customer_profile_instance_3_name                        = "customer_profile_instance_3"
customer_profile_instance_3_type                        = "t3.micro"
customer_profile_instance_3_associate_public_ip_address = false
customer_profile_instance_3_key_name                    = "customer_profile_key_pair"

################################################################################
# customer_profile_alb
################################################################################
customer_profile_alb_default_port               = 8000
customer_profile_alb_internal                   = false
customer_profile_alb_load_balancer_type         = "application"
customer_profile_alb_name                       = "customer-profile-alb"
customer_profile_alb_security_group_name        = "customer_profile_alb_sgp"
customer_profile_alb_security_group_description = "Security Group for customer_profile_alb"
customer_profile_alb_security_group_ingress_rules = {
  allow_http = {
    cidr_ipv4   = "0.0.0.0/0"
    description = "HTTP from internet"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
  }
  allow_https = {
    cidr_ipv4   = "0.0.0.0/0"
    description = "HTTPS from internet"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
  }
}
customer_profile_alb_security_group_egress_rules = {
  allow_tcp_customer_profile_instance = {
    description                  = "Allow tcp from customer_profile_alb to customer_profile_instance"
    referenced_security_group_id = null
    ip_protocol                  = "tcp"
    from_port                    = 22
    to_port                      = 22

  }
}
################################################################################
# customer_profile_alb_listeners
################################################################################
customer_profile_alb_listeners = {
  http = {
    port     = 80
    protocol = "HTTP"
    forward = {
      target_group_key = "customer_profile"
    }
  }
}
################################################################################
# customer_profile_alb_target_groups
################################################################################
customer_profile_alb_target_groups = {
  customer_profile = {
    name              = "customer-profile-tg"
    protocol          = "HTTP"
    port              = 9091
    target_type       = "instance"
    create_attachment = false # attachments are done in the module block

    deregistration_delay = 30

    health_check = {
      enabled             = true
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      matcher             = "200"
      interval            = 15
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 3
    }
  }
}
customer_profile_alb_additional_target_group_attachments = {
  instance_1 = {
    target_group_key = "customer_profile" # must match a key in var.target_groups
    target_id        = "instance_1"       # key in local.instance_ids
    port             = 9091
  }
  instance_2 = {
    target_group_key = "customer_profile"
    target_id        = "instance_2"
    port             = 9091
  }
  instance_3 = {
    target_group_key = "customer_profile"
    target_id        = "instance_3"
    port             = 9091
  }
}


################################################################################
# account_alb
################################################################################
account_alb_default_port               = 8000
account_alb_internal                   = true
account_alb_load_balancer_type         = "application"
account_alb_name                       = "account-alb"
account_alb_security_group_name        = "account_alb_sgp"
account_alb_security_group_description = "Security Group for account_alb"


################################################################################
# account_alb_listeners
################################################################################
account_alb_listeners = {
  http = {
    port     = 80
    protocol = "HTTP"
    forward = {
      target_group_key = "account"
    }
  }
}
################################################################################
# account_alb_target_groups
################################################################################
account_alb_target_groups = {
  account = {
    name              = "account-tg"
    protocol          = "HTTP"
    port              = 9092
    target_type       = "instance"
    create_attachment = false

    deregistration_delay = 30

    health_check = {
      enabled             = true
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      matcher             = "200"
      interval            = 15
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 3
    }
  }
}
account_alb_additional_target_group_attachments = {
  instance_1 = {
    target_group_key = "account"
    target_id        = "instance_1" # key in local.instance_ids
    port             = 9092
  }
  instance_2 = {
    target_group_key = "account"
    target_id        = "instance_2"
    port             = 9092
  }
  instance_3 = {
    target_group_key = "account"
    target_id        = "instance_3"
    port             = 9092
  }
}
################################################################################
# statement_alb
################################################################################
statement_alb_default_port               = 8000
statement_alb_internal                   = true
statement_alb_load_balancer_type         = "application"
statement_alb_name                       = "statement-alb"
statement_alb_security_group_name        = "statement_alb_sgp"
statement_alb_security_group_description = "Security Group for statement_alb"


################################################################################
# statement_alb_listeners
################################################################################
statement_alb_listeners = {
  http = {
    port     = 80
    protocol = "HTTP"
    forward = {
      target_group_key = "statement"
    }
  }
}
################################################################################
# statement_alb_target_groups
################################################################################
statement_alb_target_groups = {
  statement = {
    name              = "statement-tg"
    protocol          = "HTTP"
    port              = 9093
    target_type       = "instance"
    create_attachment = false

    deregistration_delay = 30

    health_check = {
      enabled             = true
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      matcher             = "200"
      interval            = 15
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 3
    }
  }
}
statement_alb_additional_target_group_attachments = {
  instance_1 = {
    target_group_key = "statement"
    target_id        = "instance_1" # key in local.instance_ids
    port             = 9093
  }
  instance_2 = {
    target_group_key = "statement"
    target_id        = "instance_2"
    port             = 9093
  }
  instance_3 = {
    target_group_key = "statement"
    target_id        = "instance_3"
    port             = 9093
  }
}
################################################################################
# account_instance_1
################################################################################
account_instance_1_name                        = "account_instance_1"
account_instance_1_type                        = "t3.micro"
account_instance_1_associate_public_ip_address = false
account_instance_1_key_name                    = "account_key_pair"
################################################################################
# account_instance_2
################################################################################
account_instance_2_name                        = "account_instance_2"
account_instance_2_type                        = "t3.micro"
account_instance_2_associate_public_ip_address = false
account_instance_2_key_name                    = "account_key_pair"
################################################################################
# account_instance_3
################################################################################
account_instance_3_name                        = "account_instance_3"
account_instance_3_type                        = "t3.micro"
account_instance_3_associate_public_ip_address = false
account_instance_3_key_name                    = "account_key_pair"

################################################################################
# account_instance_security_group
################################################################################
account_instance_security_group_name = "account_instance_sgp"
account_instance_security_group_ingress_rules = {
  allow_ssh_jump_host = {
    description = "Allow SSH from jump host"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
  }
  instance_from_alb = {
    description = "App port from account ALB"
    ip_protocol = "tcp"
    from_port   = 9092
    to_port     = 9092
  }
}
################################################################################
# statement_instance_1
################################################################################
statement_instance_1_name                        = "statement_instance_1"
statement_instance_1_type                        = "t3.micro"
statement_instance_1_associate_public_ip_address = false
statement_instance_1_key_name                    = "statement_key_pair"
################################################################################
# statement_instance_2
################################################################################
statement_instance_2_name                        = "statement_instance_2"
statement_instance_2_type                        = "t3.micro"
statement_instance_2_associate_public_ip_address = false
statement_instance_2_key_name                    = "statement_key_pair"
################################################################################
# statement_instance_3
################################################################################
statement_instance_3_name                        = "statement_instance_3"
statement_instance_3_type                        = "t3.micro"
statement_instance_3_associate_public_ip_address = false
statement_instance_3_key_name                    = "statement_key_pair"

################################################################################
# statement_instance_security_group
################################################################################
statement_instance_security_group_name = "statement_instance_sgp"
statement_instance_security_group_ingress_rules = {
  allow_ssh_jump_host = {
    description = "Allow SSH from jump host"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
  }
  instance_from_alb = {
    description = "App port from statement ALB"
    ip_protocol = "tcp"
    from_port   = 9093
    to_port     = 9093
  }
}
################################################################################
# public_hosted_zone
################################################################################
public_hosted_zone         = "hninwaiwaihlaing.work"
public_hosted_zone_comment = "Public hosted zone for hninwaiwaihlaing.work"
