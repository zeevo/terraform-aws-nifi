# terraform-aws-nifi

Create a `main.tf`.

```
provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source                    = "zeevo/nifi/aws"
  version                   = "0.2.0"
  nifi_ssh_key_name         = "my-aws-key-name"
  nifi_ssh_public_key       = "ssh-ed25519 MYPUBLICKEY..."
  nifi_node_count           = 3
  nifi_zookeeper_count      = 1
}
```

Create your cluster.

```
terraform init
terraform apply
```
