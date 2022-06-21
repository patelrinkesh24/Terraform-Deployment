output "public_subnet_ids" {
  value = module.vpc-devrp.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.vpc-devrp.private_subnet_ids
}

output "vpc_id" {
  value = module.vpc-devrp.vpc_id
}

output "private_route_table" {
  value = module.vpc-devrp.private_route_table
}


output "public_route_table" {
  value = module.vpc-devrp.public_route_table
}

output "private_cidr_blocks" {
  value = module.vpc-devrp.private_cidr_blocks
}

output "public_cidr_blocks" {
  value = module.vpc-devrp.public_cidr_blocks
}