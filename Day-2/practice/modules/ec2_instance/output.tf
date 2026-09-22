output "public_ip" {
  value = aws_instance.example.private_ip
}

output "region" {
  value = aws_instance.example.region
}

output "public_ip1" {
  value = aws_instance.example2.private_ip
}

output "region1" {
  value = aws_instance.example2.region
}