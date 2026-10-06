output "public_subnet_01" {
  value = aws_subnet.private-subnet-1.id
}

output "public_subnet_02" {
  value = aws_subnet.public-subnet-2.id
}

output "private_subnet_01" {
  value = aws_subnet.private-subnet-1.id
}

output "private_subnet_02" {
  value = aws_subnet.private-subnet-2.id
}