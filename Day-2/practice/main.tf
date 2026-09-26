# variable.tf
variable "ami_value" {
  type = string
}

variable "instance_value" {
  type = string
}

variable "subnet_id_value" {
  type = string
}

provider "aws" {
  region = "ap-south-2"
}

module "aws_ec2_instance" {
  source = "github.com/kumar5102005/terraform-zero-to-hero//Day-2/practice/modules/ec2_instance?ref=main"
  ami_value = var.ami_value
  instance_value = var.instance_value
  subnet_id_value = var.subnet_id_value
}

module "aws_ec2_instance2" {
  source = "./modules/ec2_instance"
  ami_value = var.ami_value
  instance_value = var.instance_value
  subnet_id_value = var.subnet_id_value
}