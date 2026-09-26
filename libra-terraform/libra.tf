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

# resource "aws_subnet" "pub_sub_02" {
#   vpc_id = aws_vpc.vpc.id
#   cidr_block = "172.0.1.0/24"
#   availability_zone = "ap-south-2b"
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

# resource "aws_route_table_association" "rtassoc1" {
#   route_table_id = aws_route_table.rt01.id
#   subnet_id = aws_subnet.pub_sub_01.id
# }

# resource "aws_route_table_association" "rtassoc2" {
#   route_table_id = aws_route_table.rt01.id
#   subnet_id = aws_subnet.pub_sub_02.id
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

# resource "aws_launch_template" "libraai-lunch-template" {
#   name_prefix = "libraai-lt-"
#   image_id = "ami-0199ac7c9fbf9ed83"
#   instance_type = "t3.micro"
#   key_name = aws_key_pair.example.key_name

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups = [aws_security_group.sg-libraai.id]

#   }

#   user_data = base64encode(<<-EOF
#               #!/bin/bash
#               sudo apt-get update -y
#               sudo apt-get install -y docker.io
#               sudo systemctl start docker
#               sudo systemctl enable docker
#               sudo docker run -d -p 80:80 phanikumar4139/libraai:latest
#               EOF
#   )
# }

# resource "aws_lb_target_group" "libraai_tg" {
#   name = "libraai-tg"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = aws_vpc.vpc.id
#   target_type = "instance"

#   health_check {
#     enabled = true
#     path = "/"
#     port = "80"
#     protocol = "HTTP"
#     matcher = "200"
#     interval = 30
#     timeout = 5
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb" "libraai_alb" {
#   name = "libraai-alb"
#   internal = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.sg-libraai.id]
#   subnets = [aws_subnet.pub_sub_01.id,aws_subnet.pub_sub_02.id]

#   tags = {
#     name = "libraai-alb"
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.libraai_alb.arn
#   port = 80
#   protocol = "HTTP"

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.libraai_tg.arn
#   }
# }

# resource "aws_autoscaling_group" "libraai_asg" {
#   name_prefix = "libraai-asg-"
#   desired_capacity = 2
#   max_size = 4
#   min_size = 1

#   vpc_zone_identifier = [aws_subnet.pub_sub_01.id,aws_subnet.pub_sub_02.id]

#   target_group_arns = [aws_lb_target_group.libraai_tg.arn]

#   launch_template {
#     id = aws_launch_template.libraai-lunch-template.id
#     version = "$Latest"
#   }

#   health_check_type = "ELB"
#   health_check_grace_period = 300

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# output "alb_dns_name" {
#     description = "Access your application at this URL"
#     value = aws_lb.libraai_alb.dns_name
# }