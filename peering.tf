# VPC Peering: account_vpc <-> statement_vpc
resource "aws_vpc_peering_connection" "account_statement_vpc_peering" {
  provider    = aws.osaka
  vpc_id      = module.account_vpc.vpc_id
  peer_region = var.statement_vpc_region
  peer_vpc_id = module.statement_vpc.vpc_id
  auto_accept = false

  depends_on = [
    module.account_vpc,
    module.statement_vpc
  ]
}

# 2. Accepter Side (statement_vpc)
resource "aws_vpc_peering_connection_accepter" "statement_vpc_peering_accepter" {
  provider = aws.singapore

  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement_vpc_peering.id
  auto_accept               = true

  tags = {
    Name = "account-statement-vpc-peering-accepter"
  }
}
# 3. DNS Options (Runs AFTER the accepter activates the connection)
resource "aws_vpc_peering_connection_options" "requester_dns" {
  provider                  = aws.osaka
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.statement_vpc_peering_accepter.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter_dns" {
  provider                  = aws.singapore
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.statement_vpc_peering_accepter.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
# Change route in Osaka (account-vpc private route tables -> statement-vpc)
resource "aws_route" "account_to_statement" {
  count    = length(module.account_vpc.private_route_table_ids)
  provider = aws.osaka

  route_table_id            = module.account_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.statement_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.statement_vpc_peering_accepter.id
}

# Change route in Singapore (statement-vpc private route tables -> account-vpc)
resource "aws_route" "statement_to_account" {
  count    = length(module.statement_vpc.private_route_table_ids)
  provider = aws.singapore

  route_table_id            = module.statement_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.account_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.statement_vpc_peering_accepter.id
}

#############################################################################################
# VPC Peering: customer_profile_vpc <-> account_vpc
#############################################################################################
resource "aws_vpc_peering_connection" "customer_profile_account_vpc_peering" {
  provider    = aws.tokyo
  vpc_id      = module.customer_profile_vpc.vpc_id
  peer_region = var.account_vpc_region
  peer_vpc_id = module.account_vpc.vpc_id
  auto_accept = false

  depends_on = [
    module.customer_profile_vpc,
    module.account_vpc
  ]
}

# 2. Accepter Side (customer_profile_vpc)
resource "aws_vpc_peering_connection_accepter" "customer_profile_vpc_peering_accepter" {
  provider = aws.osaka

  vpc_peering_connection_id = aws_vpc_peering_connection.customer_profile_account_vpc_peering.id
  auto_accept               = true

  tags = {
    Name = "customer_profile_vpc_peering_accepter"
  }
}
# 3. DNS Options (Runs AFTER the accepter activates the connection)
resource "aws_vpc_peering_connection_options" "customer_profile_vpn_requester_dns" {
  provider                  = aws.tokyo
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_vpc_peering_accepter.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "account_vpn_accepter_dns" {
  provider                  = aws.osaka
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_vpc_peering_accepter.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
# Change route in Tokyo (customer_profile_vpc private route tables -> account_vpc)
resource "aws_route" "customer_profile_to_account" {
  count    = length(module.customer_profile_vpc.private_route_table_ids)
  provider = aws.tokyo

  route_table_id            = module.customer_profile_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.account_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_vpc_peering_accepter.id
}

# Change route in Osaka (account_vpc private route tables -> customer_profile_vpc)
resource "aws_route" "account_to_customer_profile" {
  count    = length(module.account_vpc.private_route_table_ids)
  provider = aws.osaka

  route_table_id            = module.account_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.customer_profile_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_vpc_peering_accepter.id
}
resource "aws_route" "customer_profile_public_to_account" {
  count    = length(module.customer_profile_vpc.public_route_table_ids)
  provider = aws.tokyo

  route_table_id            = module.customer_profile_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = module.account_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_vpc_peering_accepter.id
}

#############################################################################################
# VPC Peering: customer_profile_vpc (Tokyo) <-> statement_vpc (Singapore)
#############################################################################################
resource "aws_vpc_peering_connection" "customer_profile_statement_vpc_peering" {
  provider    = aws.tokyo
  vpc_id      = module.customer_profile_vpc.vpc_id
  peer_region = var.statement_vpc_region
  peer_vpc_id = module.statement_vpc.vpc_id
  auto_accept = false

  depends_on = [
    module.customer_profile_vpc,
    module.statement_vpc
  ]
}

resource "aws_vpc_peering_connection_accepter" "customer_profile_statement_vpc_peering_accepter" {
  provider = aws.singapore

  vpc_peering_connection_id = aws_vpc_peering_connection.customer_profile_statement_vpc_peering.id
  auto_accept               = true

  tags = {
    Name = "customer-profile-statement-vpc-peering-accepter"
  }
}

# Tokyo public route tables (jump host) -> Singapore
resource "aws_route" "customer_profile_public_to_statement" {
  count    = length(module.customer_profile_vpc.public_route_table_ids)
  provider = aws.tokyo

  route_table_id            = module.customer_profile_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = module.statement_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_statement_vpc_peering_accepter.id
}

# Tokyo private route tables -> Singapore (only needed if the Tokyo private instances must reach Singapore)
resource "aws_route" "customer_profile_private_to_statement" {
  count    = length(module.customer_profile_vpc.private_route_table_ids)
  provider = aws.tokyo

  route_table_id            = module.customer_profile_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.statement_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_statement_vpc_peering_accepter.id
}

# Singapore private route tables -> Tokyo (return path for the jump host)
resource "aws_route" "statement_to_customer_profile" {
  count    = length(module.statement_vpc.private_route_table_ids)
  provider = aws.singapore

  route_table_id            = module.statement_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.customer_profile_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_profile_statement_vpc_peering_accepter.id
}