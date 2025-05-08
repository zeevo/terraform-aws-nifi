variable "nifi_name" {
  type        = string
  default     = "nifi"
  description = "A unique name for the project"
}

variable "nifi_ssh_key_name" {
  type        = string
  description = "SSH Keypair name for SSH access"
}

variable "nifi_ssh_public_key" {
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

variable "nifi_zookeeper_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "The ZooKeeper instance type"
}

variable "nifi_zookeeper_ami" {
  type        = string
  default     = "ami-058bd2d568351da34"
  description = "The ZooKeeper AMI"
}

variable "nifi_zookeeper_count" {
  type        = number
  default     = 1
  description = "The ZooKeeper cluster node count"
}

variable "nifi_node_roles" {
  type        = list(string)
  default     = ["nifi"]
  description = "The roles to assign to the NiFi nodes"
}

variable "nifi_zookeeper_roles" {
  type        = list(string)
  default     = ["zookeeper"]
  description = "The roles to assign to ZooKeeper nodes"
}

variable "nifi_node_root_block_volume_size" {
  type        = number
  default     = 20
  description = "The amount of storage of NiFi's root block device"
}

variable "nifi_zookeeper_root_block_volume_size" {
  type        = number
  default     = 20
  description = "The amount of storage of ZooKeeper's root block device"
}
