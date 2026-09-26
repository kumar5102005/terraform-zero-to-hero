provider "aws" {
    region = "ap-south-2"
}

# resource "aws_s3_bucket" "s3_remote_backend" {
#     bucket = "s3-remote-backend-phani"
# }

# output "s3_bucket_name" {
#   value = aws_s3_bucket.s3_remote_backend.bucket
# }

module "aws_ec2_instance" {
  source = "github.com/kumar5102005/terraform-zero-to-hero//Day-2/practice/modules/ec2_instance?ref=main"
  ami_value = "ami-0199ac7c9fbf9ed83"
  instance_value = "t3.micro"
  subnet_id_value = "subnet-0a2858298fe70a03b"
}

output "ec2_public_ip" {
  value = module.aws_ec2_instance.public_ip
}