
provider "aws" {
    region = "ap-south-2"
}

variable "cidr" {
  default = "172.0.0.0/16"
}

resource "aws_key_pair" "example" {
  key_name = "terraform-key-phani"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "172.0.0.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = "ap-south-2a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  route_table_id = aws_route_table.rt01.id
  subnet_id = aws_subnet.public_subnet.id
}


resource "aws_security_group" "sg01" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0199ac7c9fbf9ed83"
  instance_type          = "t3.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.sg01.id]
  subnet_id              = aws_subnet.public_subnet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo 'Hello from the remote instance'",
  #     "sudo apt update -y",  # Update package lists (for ubuntu)
  #     "sudo apt-get install -y python3-pip",  # Example package installation
  #     "sudo pip3 install flask",
  #     "cd /home/ubuntu",
  #     "sudo python3 app.py"
  #   ]
  # }

  provisioner "remote-exec" {
  inline = [
    "echo 'Hello from the remote instance'",
    "sudo apt update -y",
    "sudo apt-get install -y python3-pip python3-flask", # Installs flask system-wide via apt
    "sudo python3 /home/ubuntu/app.py"                    # Use full path to app.py
  ]
}

}