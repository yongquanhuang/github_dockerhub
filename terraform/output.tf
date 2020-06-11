output "vpc_id" {
  value = aws_vpc.billing.id
}

output "cidr_block" {
  value = aws_vpc.billing.cidr_block
}

output "private_subnets" {
  value = join(",", aws_subnet.private.*.id)
}

output "public_subnets" {
  value = join(",", aws_subnet.public.*.id)
}

output "private_db_subnets" {
  value = join(",", aws_subnet.private_db.*.id)
}

output "nat_eip" {
  value = join(",", aws_eip.nat.*.public_ip)
}

output "jumphost_eip" {
  value = aws_eip.jumphost.public_ip
}
