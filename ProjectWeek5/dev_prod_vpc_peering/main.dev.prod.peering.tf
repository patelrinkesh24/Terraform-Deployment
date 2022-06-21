
#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Accessing remote state from devrp environment

data "terraform_remote_state" "devrp_vpc" {
  backend = "s3"
  config = {
    bucket = "devrp-acs730"        // Bucket from where to GET Terraform State
    key    = "devrp-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                     // Region where bucket created
  }
}


# Accessing remote state from prodrp environment

data "terraform_remote_state" "prodrp_vpc" {
  backend = "s3"
  config = {
    bucket = "prodrp-acs730"        // Bucket from where to GET Terraform State
    key    = "prodrp-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                      // Region where bucket created
  }
}


resource "aws_vpc_peering_connection" "devrp_vpc" {
  vpc_id      = data.terraform_remote_state.devrp_vpc.outputs.vpc_id
  peer_vpc_id = data.terraform_remote_state.prodrp_vpc.outputs.vpc_id

  auto_accept = true
}


resource "aws_vpc_peering_connection_options" "devrp_vpc" {
  vpc_peering_connection_id = aws_vpc_peering_connection.devrp_vpc.id


  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}


# Add route to devrp peered VPC

resource "aws_route" "devrp_route_table_prodrp_peer" {
  count                     = length(data.terraform_remote_state.prodrp_vpc.outputs.private_cidr_blocks)
  route_table_id            = data.terraform_remote_state.devrp_vpc.outputs.public_route_table
  destination_cidr_block    = data.terraform_remote_state.prodrp_vpc.outputs.private_cidr_blocks[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.devrp_vpc.id
}

# Add route to mgmt peered VPC

resource "aws_route" "prodrp_route_table_devrp_peer" {
  count                     = length(data.terraform_remote_state.devrp_vpc.outputs.public_cidr_blocks)
  route_table_id            = data.terraform_remote_state.prodrp_vpc.outputs.private_route_table
  destination_cidr_block    = data.terraform_remote_state.devrp_vpc.outputs.public_cidr_blocks[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.devrp_vpc.id
}