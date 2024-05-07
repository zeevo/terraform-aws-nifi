provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source          = "./modules/nifi"
  ssh_key_name    = var.KEY_NAME
  ssh_public_key  = var.PUBLIC_KEY
  nifi_node_count = 50
}

variable "KEY_NAME" {
  type = string
}

variable "PUBLIC_KEY" {
  type = string
}
