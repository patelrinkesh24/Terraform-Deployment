# Add output variables
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

# Add output variables
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_route_table" {
  value = length(aws_route_table.private_route_table) > 0  ? aws_route_table.private_route_table[0].id : length(aws_route_table.private_route_table_without_ngw) > 0 ? aws_route_table.private_route_table_without_ngw[0].id : ""
}


output "public_route_table" {
   value = length(aws_route_table.public_route_table) > 0  ? aws_route_table.public_route_table[0].id : "" 
}

output "private_cidr_blocks" {
  value = var.private_cidr_blocks
}


output "public_cidr_blocks" {
  value = var.public_cidr_blocks
}