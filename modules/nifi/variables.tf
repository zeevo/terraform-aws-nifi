variable "ssh_key_name" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "nifi_node_count" {
  type    = number
  default = 1
}

variable "nifi_name" {
  type    = string
  default = "nifi"
}

variable "zookeeper_name" {
  type    = string
  default = "zookeeper"
}
