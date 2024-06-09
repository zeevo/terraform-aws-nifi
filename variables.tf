variable "ssh_key_name" {
  type        = string
  description = "SSH Keypair name for SSH access"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public key for SSH access"
}

variable "nifi_node_count" {
  type        = number
  default     = 1
  description = "The number of NiFi nodes in the cluster"
}

variable "nifi_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "The NiFi node instance type"
}

variable "nifi_ami" {
  type        = string
  default     = "ami-058bd2d568351da34"
  description = "The NiFi node AMI"
}

variable "zookeeper_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "The ZooKeeper instance type"
}

variable "zookeeper_ami" {
  type        = string
  default     = "ami-058bd2d568351da34"
  description = "The ZooKeeper AMI"
}

variable "nifi_zookeeper_count" {
  type        = number
  default     = 1
  description = "The ZooKeeper cluster node count"
}

variable "nifi_name" {
  type        = string
  default     = "nifi"
  description = "The EC2 name for NiFi nodes"
}

variable "zookeeper_name" {
  type        = string
  default     = "zookeeper"
  description = "The EC2 name for ZooKeeper nodes"
}
