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

variable "nifi_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "nifi_ami" {
  type    = string
  default = "ami-058bd2d568351da34"
}

variable "zookeeper_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "zookeeper_ami" {
  type    = string
  default = "ami-058bd2d568351da34"
}

variable "nifi_zookeeper_count" {
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
