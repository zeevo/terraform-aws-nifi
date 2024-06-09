# terraform-aws-nifi

## Getting started

Create a `main.tf`.

```
provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source          = "./modules/nifi"
  ssh_key_name    = "my-aws-key-name"
  ssh_public_key  = "ssh-ed25519 MYPUBLICKEY..."
  nifi_node_count = 3
}
```

Create your cluster

```
terraform init
terraform apply
```
