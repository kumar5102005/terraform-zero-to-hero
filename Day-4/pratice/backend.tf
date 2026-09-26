terraform {
  backend "s3" {
    bucket         = "s3-remote-backend-phani"
    key            = "phani/terraform.tfstate"
    region         = "ap-south-2"
    encrypt        = true
    use_lockfile   = true 
  }
}
