# terraform-aws-nifi

## Getting started

Create a `main.tf`.

```
provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source               = "zeevo/nifi/aws"
  version              = "0.1.0"
  ssh_key_name         = "my-aws-key-name"
  ssh_public_key       = "ssh-ed25519 MYPUBLICKEY..."
  nifi_node_count      = 3
  nifi_zookeeper_count = 2
}
```

Create your cluster

```
terraform init
terraform apply
```
