provider "aws" {
  region = "ap-south-2"
}

variable "instance_type" {
  description = "value"
}

variable "ami" {
  description = "value"
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
}