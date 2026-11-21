################################################################################
# customer_profile_vpc
################################################################################
variable "customer_profile_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "customer_profile_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}
variable "customer_profile_vpc_region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}
variable "customer_profile_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "customer_profile_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "customer_profile_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
# customer_profile_vpc_nat_gateway
variable "customer_profile_vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}
variable "customer_profile_vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
################################################################################
# account_vpc
################################################################################
variable "account_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "account_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "account_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "account_vpc_region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "account_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "account_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# statement_vpc
################################################################################
variable "statement_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "statement_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "statement_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "statement_vpc_region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "statement_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "statement_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# jump_host_instance
################################################################################
variable "jump_host_instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "jump_host_instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "jump_host_instance_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "jump_host_instance_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

################################################################################
# jump_host_instance_security_group
################################################################################
variable "jump_host_instance_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}

variable "jump_host_instance_security_group_egress_rules" {
  description = "Egress rules to add to the security group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = {
    ipv4_default = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all IPv4 traffic"
      ip_protocol = "-1"
    }
    ipv6_default = {
      cidr_ipv6   = "::/0"
      description = "Allow all IPv6 traffic"
      ip_protocol = "-1"
    }
  }
}

variable "jump_host_instance_security_group_ingress_rules" {
  description = "Ingress rules to add to the security group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = null
}


################################################################################
# customer_profile_instance_1
################################################################################
variable "customer_profile_instance_1_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "customer_profile_instance_1_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "customer_profile_instance_1_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "customer_profile_instance_1_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

# security group
variable "customer_profile_instance_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "customer_profile_instance_security_group_ingress_rules" {
  description = "Ingress rules to add to the security group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = null
}
################################################################################
# customer_profile_instance_2
################################################################################
variable "customer_profile_instance_2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "customer_profile_instance_2_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "customer_profile_instance_2_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "customer_profile_instance_2_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

################################################################################
# customer_profile_instance_3
################################################################################
variable "customer_profile_instance_3_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "customer_profile_instance_3_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "customer_profile_instance_3_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "customer_profile_instance_3_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

################################################################################
# customer_profile_alb
################################################################################
variable "customer_profile_alb_default_port" {
  description = "Default port used across the listener and target group"
  type        = number
  default     = 80
}
variable "customer_profile_alb_internal" {
  description = "If true, the LB will be internal. Defaults to `false`"
  type        = bool
  default     = null
}
variable "customer_profile_alb_load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application`"
  type        = string
  default     = "application"
}
variable "customer_profile_alb_name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null
}
variable "customer_profile_alb_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "customer_profile_alb_security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}
variable "customer_profile_alb_security_group_ingress_rules" {
  description = "Security group ingress rules to add to the security group created"
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
  }))
  default = null
}

variable "customer_profile_alb_security_group_egress_rules" {
  description = "Security group egress rules to add to the security group created"
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
  }))
  default = null
}


################################################################################
# Listener(s)
################################################################################
variable "customer_profile_alb_listeners" {
  description = "Map of listener configurations to create"
  type = map(object({
    alpn_policy                 = optional(string)
    certificate_arn             = optional(string)
    additional_certificate_arns = optional(list(string), [])
    authenticate_cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = optional(string)
      user_pool_client_id                 = optional(string)
      user_pool_domain                    = optional(string)
    }))
    authenticate_oidc = optional(object({
      authentication_request_extra_params = optional(map(string))
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      token_endpoint                      = string
      user_info_endpoint                  = string
    }))
    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(string)
    }))
    forward = optional(object({
      target_group_arn = optional(string)
      target_group_key = optional(string)
    }))
    jwt_validation = optional(object({
      issuer        = string
      jwks_endpoint = string
      additional_claim = optional(list(object({
        format = string
        name   = string
        values = list(string)
      })))
    }))
    weighted_forward = optional(object({
      target_groups = optional(list(object({
        target_group_arn = optional(string)
        target_group_key = optional(string)
        weight           = optional(number)
      })))
      stickiness = optional(object({
        duration = optional(number)
        enabled  = optional(bool)
      }))
    }))
    redirect = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = string
    }))
    mutual_authentication = optional(object({
      advertise_trust_store_ca_names   = optional(string)
      ignore_client_certificate_expiry = optional(bool)
      mode                             = string
      trust_store_arn                  = optional(string)
    }))
    order                                                                 = optional(number)
    port                                                                  = optional(number)
    protocol                                                              = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_header_name               = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_issuer_header_name        = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_leaf_header_name          = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_subject_header_name       = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_validity_header_name      = optional(string)
    routing_http_request_x_amzn_tls_cipher_suite_header_name              = optional(string)
    routing_http_request_x_amzn_tls_version_header_name                   = optional(string)
    routing_http_response_access_control_allow_credentials_header_value   = optional(string)
    routing_http_response_access_control_allow_headers_header_value       = optional(string)
    routing_http_response_access_control_allow_methods_header_value       = optional(string)
    routing_http_response_access_control_allow_origin_header_value        = optional(string)
    routing_http_response_access_control_expose_headers_header_value      = optional(string)
    routing_http_response_access_control_max_age_header_value             = optional(string)
    routing_http_response_content_security_policy_header_value            = optional(string)
    routing_http_response_server_enabled                                  = optional(bool)
    routing_http_response_strict_transport_security_header_value          = optional(string)
    routing_http_response_x_content_type_options_header_value             = optional(string)
    routing_http_response_x_frame_options_header_value                    = optional(string)
    ssl_policy                                                            = optional(string)
    tcp_idle_timeout_seconds                                              = optional(number)
    tags                                                                  = optional(map(string), {})

    # Listener rules
    rules = optional(map(object({
      actions = list(object({
        authenticate_cognito = optional(object({
          authentication_request_extra_params = optional(map(string))
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          user_pool_arn                       = string
          user_pool_client_id                 = string
          user_pool_domain                    = string
        }))
        authenticate_oidc = optional(object({
          authentication_request_extra_params = optional(map(string))
          authorization_endpoint              = string
          client_id                           = string
          client_secret                       = string
          issuer                              = string
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          token_endpoint                      = string
          user_info_endpoint                  = string
        }))
        jwt_validation = optional(object({
          issuer        = string
          jwks_endpoint = string
          additional_claim = optional(list(object({
            format = string
            name   = string
            values = list(string)
          })))
        }))
        fixed_response = optional(object({
          content_type = string
          message_body = optional(string)
          status_code  = optional(string)
        }))
        forward = optional(object({
          target_group_arn = optional(string)
          target_group_key = optional(string)
        }))
        order = optional(number)
        redirect = optional(object({
          host        = optional(string)
          path        = optional(string)
          port        = optional(string)
          protocol    = optional(string)
          query       = optional(string)
          status_code = string
        }))
        weighted_forward = optional(object({
          stickiness = optional(object({
            duration = optional(number)
            enabled  = optional(bool)
          }))
          target_groups = optional(list(object({
            target_group_arn = optional(string)
            target_group_key = optional(string)
            weight           = optional(number)
          })))
        }))
      }))
      conditions = list(object({
        host_header = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        http_header = optional(object({
          http_header_name = string
          values           = optional(list(string))
          regex_values     = optional(list(string))
        }))
        http_request_method = optional(object({
          values = list(string)
        }))
        path_pattern = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        query_string = optional(list(object({
          key   = optional(string)
          value = string
        })))
        source_ip = optional(object({
          values = list(string)
        }))
      }))
      listener_arn = optional(string)
      listener_key = optional(string)
      priority     = optional(number)
      transform = optional(map(object({
        type = optional(string)
        host_header_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
        url_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
      })))
      tags = optional(map(string), {})
    })), {})
  }))
  default = {}
}

################################################################################
# Target Group
################################################################################

variable "customer_profile_alb_target_groups" {
  description = "Map of target group configurations to create"
  type = map(object({
    connection_termination = optional(bool)
    deregistration_delay   = optional(number)
    health_check = optional(object({
      enabled             = optional(bool)
      healthy_threshold   = optional(number)
      interval            = optional(number)
      matcher             = optional(string)
      path                = optional(string)
      port                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }))
    ip_address_type                    = optional(string)
    lambda_multi_value_headers_enabled = optional(bool)
    load_balancing_algorithm_type      = optional(string)
    load_balancing_anomaly_mitigation  = optional(string)
    load_balancing_cross_zone_enabled  = optional(string)
    name                               = optional(string)
    name_prefix                        = optional(string)
    port                               = optional(number)
    preserve_client_ip                 = optional(bool)
    protocol                           = optional(string)
    protocol_version                   = optional(string)
    proxy_protocol_v2                  = optional(bool)
    slow_start                         = optional(number)
    stickiness = optional(object({
      cookie_duration = optional(number)
      cookie_name     = optional(string)
      enabled         = optional(bool)
      type            = string
    }))
    tags = optional(map(string))
    target_failover = optional(list(object({
      on_deregistration = string
      on_unhealthy      = string
    })))
    target_group_health = optional(object({
      dns_failover = optional(object({
        minimum_healthy_targets_count      = optional(string)
        minimum_healthy_targets_percentage = optional(string)
      }))
      unhealthy_state_routing = optional(object({
        minimum_healthy_targets_count      = optional(number)
        minimum_healthy_targets_percentage = optional(string)
      }))
    }))
    target_health_state = optional(object({
      enable_unhealthy_connection_termination = bool
      unhealthy_draining_interval             = optional(number)
    }))
    target_type = optional(string)
    target_id   = optional(string)
    vpc_id      = optional(string)
    # Attachment
    create_attachment = optional(bool, true)
    availability_zone = optional(string)
    # Lambda
    attach_lambda_permission  = optional(bool, false)
    lambda_qualifier          = optional(string)
    lambda_statement_id       = optional(string)
    lambda_action             = optional(string)
    lambda_principal          = optional(string)
    lambda_source_account     = optional(string)
    lambda_event_source_token = optional(string)
  }))
  default = null
}
variable "customer_profile_alb_additional_target_group_attachments" {
  description = "Map of additional target group attachments to create. Use `target_group_key` to attach to the target group created in `target_groups`"
  type = map(object({
    target_group_key  = string
    target_id         = string
    target_type       = optional(string)
    port              = optional(number)
    availability_zone = optional(string)
  }))
  default = null
}



################################################################################
# account_alb
################################################################################
variable "account_alb_default_port" {
  description = "Default port used across the listener and target group"
  type        = number
  default     = 80
}
variable "account_alb_internal" {
  description = "If true, the LB will be internal. Defaults to `false`"
  type        = bool
  default     = null
}
variable "account_alb_load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application`"
  type        = string
  default     = "application"
}
variable "account_alb_name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null
}
variable "account_alb_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "account_alb_security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}



################################################################################
# Listener(s)
################################################################################
variable "account_alb_listeners" {
  description = "Map of listener configurations to create"
  type = map(object({
    alpn_policy                 = optional(string)
    certificate_arn             = optional(string)
    additional_certificate_arns = optional(list(string), [])
    authenticate_cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = optional(string)
      user_pool_client_id                 = optional(string)
      user_pool_domain                    = optional(string)
    }))
    authenticate_oidc = optional(object({
      authentication_request_extra_params = optional(map(string))
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      token_endpoint                      = string
      user_info_endpoint                  = string
    }))
    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(string)
    }))
    forward = optional(object({
      target_group_arn = optional(string)
      target_group_key = optional(string)
    }))
    jwt_validation = optional(object({
      issuer        = string
      jwks_endpoint = string
      additional_claim = optional(list(object({
        format = string
        name   = string
        values = list(string)
      })))
    }))
    weighted_forward = optional(object({
      target_groups = optional(list(object({
        target_group_arn = optional(string)
        target_group_key = optional(string)
        weight           = optional(number)
      })))
      stickiness = optional(object({
        duration = optional(number)
        enabled  = optional(bool)
      }))
    }))
    redirect = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = string
    }))
    mutual_authentication = optional(object({
      advertise_trust_store_ca_names   = optional(string)
      ignore_client_certificate_expiry = optional(bool)
      mode                             = string
      trust_store_arn                  = optional(string)
    }))
    order                                                                 = optional(number)
    port                                                                  = optional(number)
    protocol                                                              = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_header_name               = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_issuer_header_name        = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_leaf_header_name          = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_subject_header_name       = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_validity_header_name      = optional(string)
    routing_http_request_x_amzn_tls_cipher_suite_header_name              = optional(string)
    routing_http_request_x_amzn_tls_version_header_name                   = optional(string)
    routing_http_response_access_control_allow_credentials_header_value   = optional(string)
    routing_http_response_access_control_allow_headers_header_value       = optional(string)
    routing_http_response_access_control_allow_methods_header_value       = optional(string)
    routing_http_response_access_control_allow_origin_header_value        = optional(string)
    routing_http_response_access_control_expose_headers_header_value      = optional(string)
    routing_http_response_access_control_max_age_header_value             = optional(string)
    routing_http_response_content_security_policy_header_value            = optional(string)
    routing_http_response_server_enabled                                  = optional(bool)
    routing_http_response_strict_transport_security_header_value          = optional(string)
    routing_http_response_x_content_type_options_header_value             = optional(string)
    routing_http_response_x_frame_options_header_value                    = optional(string)
    ssl_policy                                                            = optional(string)
    tcp_idle_timeout_seconds                                              = optional(number)
    tags                                                                  = optional(map(string), {})

    # Listener rules
    rules = optional(map(object({
      actions = list(object({
        authenticate_cognito = optional(object({
          authentication_request_extra_params = optional(map(string))
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          user_pool_arn                       = string
          user_pool_client_id                 = string
          user_pool_domain                    = string
        }))
        authenticate_oidc = optional(object({
          authentication_request_extra_params = optional(map(string))
          authorization_endpoint              = string
          client_id                           = string
          client_secret                       = string
          issuer                              = string
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          token_endpoint                      = string
          user_info_endpoint                  = string
        }))
        jwt_validation = optional(object({
          issuer        = string
          jwks_endpoint = string
          additional_claim = optional(list(object({
            format = string
            name   = string
            values = list(string)
          })))
        }))
        fixed_response = optional(object({
          content_type = string
          message_body = optional(string)
          status_code  = optional(string)
        }))
        forward = optional(object({
          target_group_arn = optional(string)
          target_group_key = optional(string)
        }))
        order = optional(number)
        redirect = optional(object({
          host        = optional(string)
          path        = optional(string)
          port        = optional(string)
          protocol    = optional(string)
          query       = optional(string)
          status_code = string
        }))
        weighted_forward = optional(object({
          stickiness = optional(object({
            duration = optional(number)
            enabled  = optional(bool)
          }))
          target_groups = optional(list(object({
            target_group_arn = optional(string)
            target_group_key = optional(string)
            weight           = optional(number)
          })))
        }))
      }))
      conditions = list(object({
        host_header = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        http_header = optional(object({
          http_header_name = string
          values           = optional(list(string))
          regex_values     = optional(list(string))
        }))
        http_request_method = optional(object({
          values = list(string)
        }))
        path_pattern = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        query_string = optional(list(object({
          key   = optional(string)
          value = string
        })))
        source_ip = optional(object({
          values = list(string)
        }))
      }))
      listener_arn = optional(string)
      listener_key = optional(string)
      priority     = optional(number)
      transform = optional(map(object({
        type = optional(string)
        host_header_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
        url_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
      })))
      tags = optional(map(string), {})
    })), {})
  }))
  default = {}
}

################################################################################
# Target Group
################################################################################

variable "account_alb_target_groups" {
  description = "Map of target group configurations to create"
  type = map(object({
    connection_termination = optional(bool)
    deregistration_delay   = optional(number)
    health_check = optional(object({
      enabled             = optional(bool)
      healthy_threshold   = optional(number)
      interval            = optional(number)
      matcher             = optional(string)
      path                = optional(string)
      port                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }))
    ip_address_type                    = optional(string)
    lambda_multi_value_headers_enabled = optional(bool)
    load_balancing_algorithm_type      = optional(string)
    load_balancing_anomaly_mitigation  = optional(string)
    load_balancing_cross_zone_enabled  = optional(string)
    name                               = optional(string)
    name_prefix                        = optional(string)
    port                               = optional(number)
    preserve_client_ip                 = optional(bool)
    protocol                           = optional(string)
    protocol_version                   = optional(string)
    proxy_protocol_v2                  = optional(bool)
    slow_start                         = optional(number)
    stickiness = optional(object({
      cookie_duration = optional(number)
      cookie_name     = optional(string)
      enabled         = optional(bool)
      type            = string
    }))
    tags = optional(map(string))
    target_failover = optional(list(object({
      on_deregistration = string
      on_unhealthy      = string
    })))
    target_group_health = optional(object({
      dns_failover = optional(object({
        minimum_healthy_targets_count      = optional(string)
        minimum_healthy_targets_percentage = optional(string)
      }))
      unhealthy_state_routing = optional(object({
        minimum_healthy_targets_count      = optional(number)
        minimum_healthy_targets_percentage = optional(string)
      }))
    }))
    target_health_state = optional(object({
      enable_unhealthy_connection_termination = bool
      unhealthy_draining_interval             = optional(number)
    }))
    target_type = optional(string)
    target_id   = optional(string)
    vpc_id      = optional(string)
    # Attachment
    create_attachment = optional(bool, true)
    availability_zone = optional(string)
    # Lambda
    attach_lambda_permission  = optional(bool, false)
    lambda_qualifier          = optional(string)
    lambda_statement_id       = optional(string)
    lambda_action             = optional(string)
    lambda_principal          = optional(string)
    lambda_source_account     = optional(string)
    lambda_event_source_token = optional(string)
  }))
  default = null
}
variable "account_alb_additional_target_group_attachments" {
  description = "Map of additional target group attachments to create. Use `target_group_key` to attach to the target group created in `target_groups`"
  type = map(object({
    target_group_key  = string
    target_id         = string
    target_type       = optional(string)
    port              = optional(number)
    availability_zone = optional(string)
  }))
  default = null
}


################################################################################
# statement_alb
################################################################################
variable "statement_alb_default_port" {
  description = "Default port used across the listener and target group"
  type        = number
  default     = 80
}
variable "statement_alb_internal" {
  description = "If true, the LB will be internal. Defaults to `false`"
  type        = bool
  default     = null
}
variable "statement_alb_load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application`"
  type        = string
  default     = "application"
}
variable "statement_alb_name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null
}
variable "statement_alb_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "statement_alb_security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}

################################################################################
# Listener(s)
################################################################################
variable "statement_alb_listeners" {
  description = "Map of listener configurations to create"
  type = map(object({
    alpn_policy                 = optional(string)
    certificate_arn             = optional(string)
    additional_certificate_arns = optional(list(string), [])
    authenticate_cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = optional(string)
      user_pool_client_id                 = optional(string)
      user_pool_domain                    = optional(string)
    }))
    authenticate_oidc = optional(object({
      authentication_request_extra_params = optional(map(string))
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      token_endpoint                      = string
      user_info_endpoint                  = string
    }))
    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(string)
    }))
    forward = optional(object({
      target_group_arn = optional(string)
      target_group_key = optional(string)
    }))
    jwt_validation = optional(object({
      issuer        = string
      jwks_endpoint = string
      additional_claim = optional(list(object({
        format = string
        name   = string
        values = list(string)
      })))
    }))
    weighted_forward = optional(object({
      target_groups = optional(list(object({
        target_group_arn = optional(string)
        target_group_key = optional(string)
        weight           = optional(number)
      })))
      stickiness = optional(object({
        duration = optional(number)
        enabled  = optional(bool)
      }))
    }))
    redirect = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = string
    }))
    mutual_authentication = optional(object({
      advertise_trust_store_ca_names   = optional(string)
      ignore_client_certificate_expiry = optional(bool)
      mode                             = string
      trust_store_arn                  = optional(string)
    }))
    order                                                                 = optional(number)
    port                                                                  = optional(number)
    protocol                                                              = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_header_name               = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_issuer_header_name        = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_leaf_header_name          = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_subject_header_name       = optional(string)
    routing_http_request_x_amzn_mtls_clientcert_validity_header_name      = optional(string)
    routing_http_request_x_amzn_tls_cipher_suite_header_name              = optional(string)
    routing_http_request_x_amzn_tls_version_header_name                   = optional(string)
    routing_http_response_access_control_allow_credentials_header_value   = optional(string)
    routing_http_response_access_control_allow_headers_header_value       = optional(string)
    routing_http_response_access_control_allow_methods_header_value       = optional(string)
    routing_http_response_access_control_allow_origin_header_value        = optional(string)
    routing_http_response_access_control_expose_headers_header_value      = optional(string)
    routing_http_response_access_control_max_age_header_value             = optional(string)
    routing_http_response_content_security_policy_header_value            = optional(string)
    routing_http_response_server_enabled                                  = optional(bool)
    routing_http_response_strict_transport_security_header_value          = optional(string)
    routing_http_response_x_content_type_options_header_value             = optional(string)
    routing_http_response_x_frame_options_header_value                    = optional(string)
    ssl_policy                                                            = optional(string)
    tcp_idle_timeout_seconds                                              = optional(number)
    tags                                                                  = optional(map(string), {})

    # Listener rules
    rules = optional(map(object({
      actions = list(object({
        authenticate_cognito = optional(object({
          authentication_request_extra_params = optional(map(string))
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          user_pool_arn                       = string
          user_pool_client_id                 = string
          user_pool_domain                    = string
        }))
        authenticate_oidc = optional(object({
          authentication_request_extra_params = optional(map(string))
          authorization_endpoint              = string
          client_id                           = string
          client_secret                       = string
          issuer                              = string
          on_unauthenticated_request          = optional(string)
          scope                               = optional(string)
          session_cookie_name                 = optional(string)
          session_timeout                     = optional(number)
          token_endpoint                      = string
          user_info_endpoint                  = string
        }))
        jwt_validation = optional(object({
          issuer        = string
          jwks_endpoint = string
          additional_claim = optional(list(object({
            format = string
            name   = string
            values = list(string)
          })))
        }))
        fixed_response = optional(object({
          content_type = string
          message_body = optional(string)
          status_code  = optional(string)
        }))
        forward = optional(object({
          target_group_arn = optional(string)
          target_group_key = optional(string)
        }))
        order = optional(number)
        redirect = optional(object({
          host        = optional(string)
          path        = optional(string)
          port        = optional(string)
          protocol    = optional(string)
          query       = optional(string)
          status_code = string
        }))
        weighted_forward = optional(object({
          stickiness = optional(object({
            duration = optional(number)
            enabled  = optional(bool)
          }))
          target_groups = optional(list(object({
            target_group_arn = optional(string)
            target_group_key = optional(string)
            weight           = optional(number)
          })))
        }))
      }))
      conditions = list(object({
        host_header = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        http_header = optional(object({
          http_header_name = string
          values           = optional(list(string))
          regex_values     = optional(list(string))
        }))
        http_request_method = optional(object({
          values = list(string)
        }))
        path_pattern = optional(object({
          values       = optional(list(string))
          regex_values = optional(list(string))
        }))
        query_string = optional(list(object({
          key   = optional(string)
          value = string
        })))
        source_ip = optional(object({
          values = list(string)
        }))
      }))
      listener_arn = optional(string)
      listener_key = optional(string)
      priority     = optional(number)
      transform = optional(map(object({
        type = optional(string)
        host_header_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
        url_rewrite_config = optional(object({
          rewrite = optional(object({
            regex   = string
            replace = string
          }))
        }))
      })))
      tags = optional(map(string), {})
    })), {})
  }))
  default = {}
}

################################################################################
# Target Group
################################################################################

variable "statement_alb_target_groups" {
  description = "Map of target group configurations to create"
  type = map(object({
    connection_termination = optional(bool)
    deregistration_delay   = optional(number)
    health_check = optional(object({
      enabled             = optional(bool)
      healthy_threshold   = optional(number)
      interval            = optional(number)
      matcher             = optional(string)
      path                = optional(string)
      port                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }))
    ip_address_type                    = optional(string)
    lambda_multi_value_headers_enabled = optional(bool)
    load_balancing_algorithm_type      = optional(string)
    load_balancing_anomaly_mitigation  = optional(string)
    load_balancing_cross_zone_enabled  = optional(string)
    name                               = optional(string)
    name_prefix                        = optional(string)
    port                               = optional(number)
    preserve_client_ip                 = optional(bool)
    protocol                           = optional(string)
    protocol_version                   = optional(string)
    proxy_protocol_v2                  = optional(bool)
    slow_start                         = optional(number)
    stickiness = optional(object({
      cookie_duration = optional(number)
      cookie_name     = optional(string)
      enabled         = optional(bool)
      type            = string
    }))
    tags = optional(map(string))
    target_failover = optional(list(object({
      on_deregistration = string
      on_unhealthy      = string
    })))
    target_group_health = optional(object({
      dns_failover = optional(object({
        minimum_healthy_targets_count      = optional(string)
        minimum_healthy_targets_percentage = optional(string)
      }))
      unhealthy_state_routing = optional(object({
        minimum_healthy_targets_count      = optional(number)
        minimum_healthy_targets_percentage = optional(string)
      }))
    }))
    target_health_state = optional(object({
      enable_unhealthy_connection_termination = bool
      unhealthy_draining_interval             = optional(number)
    }))
    target_type = optional(string)
    target_id   = optional(string)
    vpc_id      = optional(string)
    # Attachment
    create_attachment = optional(bool, true)
    availability_zone = optional(string)
    # Lambda
    attach_lambda_permission  = optional(bool, false)
    lambda_qualifier          = optional(string)
    lambda_statement_id       = optional(string)
    lambda_action             = optional(string)
    lambda_principal          = optional(string)
    lambda_source_account     = optional(string)
    lambda_event_source_token = optional(string)
  }))
  default = null
}
variable "statement_alb_additional_target_group_attachments" {
  description = "Map of additional target group attachments to create. Use `target_group_key` to attach to the target group created in `target_groups`"
  type = map(object({
    target_group_key  = string
    target_id         = string
    target_type       = optional(string)
    port              = optional(number)
    availability_zone = optional(string)
  }))
  default = null
}

################################################################################
# account_instance_1
################################################################################
variable "account_instance_1_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "account_instance_1_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "account_instance_1_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "account_instance_1_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

# security group
variable "account_instance_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "account_instance_security_group_ingress_rules" {
  description = "Ingress rules to add to the security group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = null
}
################################################################################
# account_instance_2
################################################################################
variable "account_instance_2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "account_instance_2_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "account_instance_2_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "account_instance_2_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

################################################################################
# account_instance_3
################################################################################
variable "account_instance_3_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "account_instance_3_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "account_instance_3_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "account_instance_3_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

################################################################################
# statement_instance_1
################################################################################
variable "statement_instance_1_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "statement_instance_1_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "statement_instance_1_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "statement_instance_1_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

# security group
variable "statement_instance_security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}
variable "statement_instance_security_group_ingress_rules" {
  description = "Ingress rules to add to the security group"
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = null
}
################################################################################
# statement_instance_2
################################################################################
variable "statement_instance_2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "statement_instance_2_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "statement_instance_2_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "statement_instance_2_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

################################################################################
# statement_instance_3
################################################################################
variable "statement_instance_3_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "statement_instance_3_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "statement_instance_3_associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}
variable "statement_instance_3_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}
################################################################################
# public_hosted_zone
################################################################################
variable "public_hosted_zone" {
  description = "This is the name of the hosted zone"
  type        = string
  default     = ""
}
variable "public_hosted_zone_comment" {
  description = "A comment for the hosted zone. Defaults to `Managed by Terraform`"
  type        = string
  default     = null
}