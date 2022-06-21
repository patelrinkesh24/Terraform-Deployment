# Step 10 - Add output variables
output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_eip" {
  value = aws_eip.static_eip.public_ip
}