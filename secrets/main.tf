provider "aws" {
  region = "ap-south-2"
}

provider "vault" {
  address = "http://16.113.28.243:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "153c83af-fda1-263c-072e-986f449f82b4"
      secret_id = "98514f16-9bde-93bc-b4b1-2b308af93b58"
    }
  }
}

data "vault_kv_secret" "secret_data" {
  path = "kv/data/test-secret"
}

# output "secret" {
#   value = data.vault_kv_secret.secret_data
# }

resource "aws_instance" "my_instance" {
  ami           = "ami-0199ac7c9fbf9ed83"
  instance_type = "t3.micro"

  tags = {
    Secret = jsondecode(data.vault_kv_secret.secret_data.data_json).data["username"]
  }
}