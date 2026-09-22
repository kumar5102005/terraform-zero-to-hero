
resource "aws_instance" "example" {
  ami = var.ami_value
  instance_type = var.instance_value
  subnet_id = var.subnet_id_value
}

resource "aws_instance" "example2" {
  ami = var.ami_value
  instance_type = var.instance_value
  subnet_id = var.subnet_id_value
}