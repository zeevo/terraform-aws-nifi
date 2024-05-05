provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source     = "./modules/nifi"
  KEY_NAME   = var.KEY_NAME
  PUBLIC_KEY = var.PUBLIC_KEY
}

variable "KEY_NAME" {
  type = string
}

variable "PUBLIC_KEY" {
  type = string
}
