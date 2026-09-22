provider "aws" {
    region = "ap-south-2"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-0199ac7c9fbf9ed83"  # Specify an appropriate AMI ID
    instance_type = "t3.micro"
    key_name = "cluster-key"
    subnet_id = "subnet-0a2858298fe70a03b"

    tags = {
        Name="terraform_web"
    }
}