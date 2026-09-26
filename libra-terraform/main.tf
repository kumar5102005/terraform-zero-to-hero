# provider "aws" {
#   region = "ap-south-2"
# }

# variable "cidr" {
#   default = "172.0.0.0/16"
# }

# resource "aws_key_pair" "example" {
#   key_name = "libraai-key"
#   public_key = file("phani.pub")
# }

# resource "aws_vpc" "vpc" {
#   cidr_block = var.cidr
# }

# resource "aws_subnet" "pub_sub_01" {
#   vpc_id = aws_vpc.vpc.id
#   cidr_block = "172.0.0.0/24"
#   availability_zone = "ap-south-2a"
#   map_public_ip_on_launch = true
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id
# }

# resource "aws_route_table" "rt01" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

# }

# resource "aws_route_table_association" "rtassoc" {
#   route_table_id = aws_route_table.rt01.id
#   subnet_id = aws_subnet.pub_sub_01.id
# }

# resource "aws_security_group" "sg-libraai" {
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     description = "ssh"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "opening port no 80 for http"
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "webserver" {
#   ami                    = "ami-0199ac7c9fbf9ed83"
#   instance_type          = "t3.micro"
#   key_name      = aws_key_pair.example.key_name
#   vpc_security_group_ids = [aws_security_group.sg-libraai.id]
#   subnet_id              = aws_subnet.pub_sub_01.id
#   associate_public_ip_address = true


#   connection {
#     type        = "ssh"
#     user        = "ubuntu" # Standard user for Ubuntu AMIs
#     private_key = file("phani")
#     host        = self.public_ip
#   }

#   provisioner "remote-exec" {
#     inline = [ 
#         "sudo apt-get update -y",
#         "sudo apt-get install -y docker.io",
#         "sudo systemctl start docker",
#         "sudo systemctl enable docker",
#         "sudo docker run -d -p 80:80 phanikumar4139/libraai:latest",
#      ]
#   }

# #     user_data = <<-EOF
# #               #!/bin/bash
# #               sudo apt-get update -y
# #               sudo apt-get install -y docker.io
# #               sudo systemctl start docker
# #               sudo systemctl enable docker
# #               sudo docker -d -p 80:80 phanikumar4139/libraai
# #               EOF
# }


# output "public_ip" {
#   value = aws_instance.webserver.public_ip
# }