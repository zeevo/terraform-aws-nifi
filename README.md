# terraform-aws-nifi

Create a `main.tf`.

```
provider "aws" {
  region = "us-east-1"
}

module "nifi" {
provider "aws" {
  region = "us-east-1"
}

module "nifi" {
  source               = "zeevo/nifi/aws"
  nifi_name            = "nifi"
  nifi_ssh_public_key  = "ssh-ed25519 MYPUBLICKEY..."
  nifi_node_roles      = ["nifi", "docker"]
  nifi_node_count      = 1
  nifi_zookeeper_count = 1
}
```

Create your cluster.

```
terraform init
terraform apply
```
