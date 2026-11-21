locals {
  customer_profile_instances = {
    instance_1 = {
      id         = module.customer_profile_instance_1.id
      private_ip = module.customer_profile_instance_1.private_ip
    }
    instance_2 = {
      id         = module.customer_profile_instance_2.id
      private_ip = module.customer_profile_instance_2.private_ip
    }
    instance_3 = {
      id         = module.customer_profile_instance_3.id
      private_ip = module.customer_profile_instance_3.private_ip

    }
  }
  account_instances = {
    instance_1 = {
      id         = module.account_instance_1.id
      private_ip = module.account_instance_1.private_ip
    }
    instance_2 = {
      id         = module.account_instance_2.id
      private_ip = module.account_instance_2.private_ip
    }
    instance_3 = {
      id         = module.account_instance_3.id
      private_ip = module.account_instance_3.private_ip

    }
  }
  statement_instances = {
    instance_1 = {
      id         = module.statement_instance_1.id
      private_ip = module.statement_instance_1.private_ip
    }
    instance_2 = {
      id         = module.statement_instance_2.id
      private_ip = module.statement_instance_2.private_ip
    }
    instance_3 = {
      id         = module.statement_instance_3.id
      private_ip = module.statement_instance_3.private_ip

    }
  }
  customer_profile_user_data = replace(
    file("${path.module}/scripts/customer_profile_userdata.sh"),
    "__ACCOUNT_ALB_DNS__",
    module.account_alb.dns_name
  )
  account_user_data = replace(
    file("${path.module}/scripts/account_userdata.sh"),
    "__STATEMENT_ALB_DNS__",
    module.statement_alb.dns_name
  )
}
module "jump_host_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.tokyo
  }

  name = var.jump_host_instance_name

  instance_type               = var.jump_host_instance_type
  key_name                    = var.jump_host_instance_key_name
  subnet_id                   = module.customer_profile_vpc.public_subnets[0]
  associate_public_ip_address = var.jump_host_instance_associate_public_ip_address

  # jump_host_instance_security_group
  security_group_name          = var.jump_host_instance_security_group_name
  security_group_vpc_id        = module.customer_profile_vpc.vpc_id
  security_group_ingress_rules = var.jump_host_instance_security_group_ingress_rules
}

# customer_profile_instance in private subnet(10.3.201.0/24)
module "customer_profile_instance_1" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.tokyo
  }

  name = var.customer_profile_instance_1_name

  instance_type = var.customer_profile_instance_1_type
  key_name      = var.customer_profile_instance_1_key_name
  subnet_id     = module.customer_profile_vpc.private_subnets[0]

  user_data                   = local.customer_profile_user_data
  user_data_replace_on_change = true

  # customer_profile_instance_security_group
  security_group_name   = var.customer_profile_instance_security_group_name
  security_group_vpc_id = module.customer_profile_vpc.vpc_id
  security_group_ingress_rules = {
    for key, rule in coalesce(var.customer_profile_instance_security_group_ingress_rules, {}) :
    key => merge(rule, {
      referenced_security_group_id = (
        key == "allow_ssh_jump_host" ? module.jump_host_instance.security_group_id :
        key == "instance_from_alb" ? module.customer_profile_alb.security_group_id :
        rule.referenced_security_group_id
      )
    })
  }

  security_group_egress_rules = {
    allow_all_ipv4 = {
      description = "Allow all outbound IPv4"
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
    to_account_alb = {
      description = "Allow traffic to account ALB (Osaka)"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = module.account_vpc.vpc_cidr_block
    }
  }
}

module "customer_profile_instance_2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.tokyo
  }

  name = var.customer_profile_instance_2_name

  instance_type = var.customer_profile_instance_2_type
  key_name      = var.customer_profile_instance_2_key_name
  subnet_id     = module.customer_profile_vpc.private_subnets[1]

  #user_data                   = file("${path.module}/scripts/customer_profile_userdata.sh")
  user_data                   = local.customer_profile_user_data
  user_data_replace_on_change = true

  # common use customer_profile_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.customer_profile_instance_1.security_group_id]
}

module "customer_profile_instance_3" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.tokyo
  }

  name = var.customer_profile_instance_3_name

  instance_type = var.customer_profile_instance_3_type
  key_name      = var.customer_profile_instance_3_key_name
  subnet_id     = module.customer_profile_vpc.private_subnets[2]

  user_data                   = local.customer_profile_user_data
  user_data_replace_on_change = true

  # common use customer_profile_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.customer_profile_instance_1.security_group_id]
}


resource "null_resource" "copy_to_customer_profile" {
  for_each = local.customer_profile_instances

  triggers = {
    instance_id = each.value.id
  }

  provisioner "local-exec" {
    command = <<EOT
    SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o BatchMode=yes"
    PROXY="ssh -i ./keypairs/jump-host-keypair.pem $SSH_OPTS -W %h:%p ec2-user@${module.jump_host_instance.public_ip}"

    for i in $(seq 1 20); do
    if scp -i ./keypairs/customer_profile_key_pair.pem $SSH_OPTS \
        -o "ProxyCommand=$PROXY" \
        ./scripts/fake-service.zip ec2-user@${each.value.private_ip}:~ ; then
        echo "[${each.key}] copy succeeded"; exit 0
    fi
    echo "[${each.key}] attempt $i failed, retrying in 10s"; sleep 10
    done
    echo "[${each.key}] copy failed"; exit 1
    EOT
  }

  depends_on = [
    module.customer_profile_instance_1,
    module.customer_profile_instance_2,
    module.customer_profile_instance_3,
    module.jump_host_instance,
  ]
}
################################################################################
# account_instance
################################################################################
resource "null_resource" "copy_to_account" {
  for_each = local.account_instances

  triggers = {
    instance_id = each.value.id
  }

  provisioner "local-exec" {
    command = <<EOT
    SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o BatchMode=yes"
    PROXY="ssh -i ./keypairs/jump-host-keypair.pem $SSH_OPTS -W %h:%p ec2-user@${module.jump_host_instance.public_ip}"

    for i in $(seq 1 20); do
    if scp -i ./keypairs/account_key_pair.pem $SSH_OPTS \
        -o "ProxyCommand=$PROXY" \
        ./scripts/fake-service.zip ec2-user@${each.value.private_ip}:~ ; then
        echo "[${each.key}] copy succeeded"; exit 0
    fi
    echo "[${each.key}] attempt $i failed, retrying in 10s"; sleep 10
    done
    echo "[${each.key}] copy failed"; exit 1
    EOT
  }

  depends_on = [
    module.account_instance_1,
    module.account_instance_2,
    module.account_instance_3,
    module.jump_host_instance,
    aws_route.customer_profile_public_to_account,
    aws_route.account_to_customer_profile,
  ]
}
# account_instance in private subnet(10.2.201.0/24)
module "account_instance_1" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.osaka
  }

  name = var.account_instance_1_name

  instance_type = var.account_instance_1_type
  key_name      = var.account_instance_1_key_name
  subnet_id     = module.account_vpc.private_subnets[0]

  user_data                   = local.account_user_data
  user_data_replace_on_change = true

  # account_instance_security_group
  security_group_name   = var.account_instance_security_group_name
  security_group_vpc_id = module.account_vpc.vpc_id
  security_group_ingress_rules = {
    for key, rule in coalesce(var.account_instance_security_group_ingress_rules, {}) :
    key => merge(rule, {
      cidr_ipv4 = (
        key == "allow_ssh_jump_host"
        ? "${module.jump_host_instance.private_ip}/32"
        : try(rule.cidr_ipv4, null)
      )
      referenced_security_group_id = (
        key == "instance_from_alb"
        ? module.account_alb.security_group_id
        : try(rule.referenced_security_group_id, null)
      )
    })
  }
}

module "account_instance_2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.osaka
  }

  name = var.account_instance_2_name

  instance_type = var.account_instance_2_type
  key_name      = var.account_instance_2_key_name
  subnet_id     = module.account_vpc.private_subnets[1]

  user_data                   = local.account_user_data
  user_data_replace_on_change = true

  # common use account_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.account_instance_1.security_group_id]
}
module "account_instance_3" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.osaka
  }

  name = var.account_instance_3_name

  instance_type = var.account_instance_3_type
  key_name      = var.account_instance_3_key_name
  subnet_id     = module.account_vpc.private_subnets[2]

  user_data                   = local.account_user_data
  user_data_replace_on_change = true

  # common use account_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.account_instance_1.security_group_id]
}
################################################################################
# statement_instance
################################################################################
resource "null_resource" "copy_to_statement" {
  for_each = local.statement_instances

  triggers = {
    instance_id = each.value.id
  }

  provisioner "local-exec" {
    command = <<EOT
    SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o BatchMode=yes"
    PROXY="ssh -i ./keypairs/jump-host-keypair.pem $SSH_OPTS -W %h:%p ec2-user@${module.jump_host_instance.public_ip}"

    for i in $(seq 1 20); do
    if scp -i ./keypairs/statement_key_pair.pem $SSH_OPTS \
        -o "ProxyCommand=$PROXY" \
        ./scripts/fake-service.zip ec2-user@${each.value.private_ip}:~ ; then
        echo "[${each.key}] copy succeeded"; exit 0
    fi
    echo "[${each.key}] attempt $i failed, retrying in 10s"; sleep 10
    done
    echo "[${each.key}] copy failed"; exit 1
    EOT
  }

  depends_on = [
    module.statement_instance_1,
    module.jump_host_instance,
    aws_route.customer_profile_public_to_statement,
    aws_route.statement_to_customer_profile,
  ]
}
# statement_instance in private subnet(10.3.201.0/24)
module "statement_instance_1" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.singapore
  }

  name = var.statement_instance_1_name

  instance_type = var.statement_instance_1_type
  key_name      = var.statement_instance_1_key_name
  subnet_id     = module.statement_vpc.private_subnets[0]

  user_data = file("${path.module}/scripts/statement_userdata.sh")


  user_data_replace_on_change = true

  # statement_instance_security_group
  security_group_name   = var.statement_instance_security_group_name
  security_group_vpc_id = module.statement_vpc.vpc_id
  security_group_ingress_rules = {
    for key, rule in coalesce(var.statement_instance_security_group_ingress_rules, {}) :
    key => merge(rule, {
      cidr_ipv4 = (
        key == "allow_ssh_jump_host"
        ? "${module.jump_host_instance.private_ip}/32"
        : try(rule.cidr_ipv4, null)
      )
      referenced_security_group_id = (
        key == "instance_from_alb"
        ? module.statement_alb.security_group_id
        : try(rule.referenced_security_group_id, null)
      )
    })
  }
}

module "statement_instance_2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.singapore
  }

  name = var.statement_instance_2_name

  instance_type = var.statement_instance_2_type
  key_name      = var.statement_instance_2_key_name
  subnet_id     = module.statement_vpc.private_subnets[1]

  user_data                   = file("${path.module}/scripts/statement_userdata.sh")
  user_data_replace_on_change = true

  # common use statement_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.statement_instance_1.security_group_id]
}
module "statement_instance_3" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = aws.singapore
  }

  name = var.statement_instance_3_name

  instance_type = var.statement_instance_3_type
  key_name      = var.statement_instance_3_key_name
  subnet_id     = module.statement_vpc.private_subnets[2]

  user_data                   = file("${path.module}/scripts/statement_userdata.sh")
  user_data_replace_on_change = true

  # common use statement_instance_security_group
  create_security_group  = false
  vpc_security_group_ids = [module.statement_instance_1.security_group_id]
}