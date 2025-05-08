resource "aws_key_pair" "nifi_ssh" {
  key_name   = var.nifi_ssh_key_name
  public_key = var.nifi_ssh_public_key
}

resource "aws_instance" "nifi_node" {
  ami           = var.nifi_ami
  instance_type = var.nifi_instance_type
  key_name      = aws_key_pair.nifi_ssh.key_name
  tags = {
    Name  = "${var.nifi_name}-node-${count.index}"
    roles = jsonencode(var.nifi_node_roles)
  }
  root_block_device {
    volume_size = var.nifi_node_root_block_volume_size
  }
  count = var.nifi_node_count
}


resource "aws_instance" "zookeeper" {
  ami           = var.nifi_zookeeper_ami
  instance_type = var.nifi_zookeeper_instance_type
  key_name      = aws_key_pair.nifi_ssh.key_name
  tags = {
    Name  = "${var.nifi_name}-zookeeper-${count.index}"
    roles = jsonencode(var.nifi_zookeeper_roles)
  }
  root_block_device {
    volume_size = var.nifi_zookeeper_root_block_volume_size
  }
  count = var.nifi_zookeeper_count
}

resource "aws_security_group" "all" {
  name = "${var.nifi_name}_all_sg"
}

resource "aws_security_group" "nifi_nodes" {
  name = "${var.nifi_name}_nifi_nodes"
  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Cluster"
      from_port        = 11443
      to_port          = 11443
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.all.id]
      self             = true
    },
    {
      description      = "UI"
      from_port        = 8443
      to_port          = 8443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Load Balance"
      from_port        = 6342
      to_port          = 6342
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.all.id]
      self             = true
    }
  ]
}

resource "aws_security_group" "nifi_zookeeper" {
  name = "${var.nifi_name}_zookeeper_nodes"
  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Zookeeper clients"
      from_port        = 2181
      to_port          = 2181
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.all.id]
      self             = true
    },
    {
      description      = "Zookeeper followers"
      from_port        = 2888
      to_port          = 2888
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.all.id]
      self             = true
    },
    {
      description      = "Zookeeper elections"
      from_port        = 3888
      to_port          = 3888
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.all.id]
      self             = true
    }
  ]
}

resource "aws_network_interface_sg_attachment" "nifi_security_group_attachment" {
  security_group_id    = aws_security_group.nifi_nodes.id
  network_interface_id = aws_instance.nifi_node[count.index].primary_network_interface_id
  count                = var.nifi_node_count
}

resource "aws_network_interface_sg_attachment" "all_nodes_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.nifi_node[count.index].primary_network_interface_id
  count                = var.nifi_node_count
}

resource "aws_network_interface_sg_attachment" "zookeeper_primary_security_group_attachment" {
  security_group_id    = aws_security_group.nifi_zookeeper.id
  network_interface_id = aws_instance.zookeeper[count.index].primary_network_interface_id
  count                = var.nifi_zookeeper_count
}

resource "aws_network_interface_sg_attachment" "all_zookeeper_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.zookeeper[count.index].primary_network_interface_id
  count                = var.nifi_zookeeper_count
}

