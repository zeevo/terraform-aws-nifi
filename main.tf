resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "node" {
  ami           = var.nifi_ami
  instance_type = var.nifi_instance_type
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "${var.nifi_name}-${count.index}"
    Role = "nifi"
  }
  count = var.nifi_node_count
  root_block_device {
    volume_size = 20
  }
}

resource "aws_instance" "zookeeper" {
  ami           = var.zookeeper_ami
  instance_type = var.zookeeper_instance_type
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "${var.zookeeper_name}-${count.index}"
    Role = "zookeeper"
  }
  count = var.nifi_zookeeper_count
}

resource "aws_security_group" "all" {
  name = "nifi"
}

resource "aws_security_group" "nodes" {
  name = "nifi_nodes"
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
      from_port        = 8082
      to_port          = 8082
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
      security_groups  = [aws_security_group.all.id]
      self             = true
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

resource "aws_security_group" "zookeeper" {
  name = "nifi_zookeeper"
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
  security_group_id    = aws_security_group.nodes.id
  network_interface_id = aws_instance.node[count.index].primary_network_interface_id
  count                = var.nifi_node_count
}

resource "aws_network_interface_sg_attachment" "all_nodes_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.node[count.index].primary_network_interface_id
  count                = var.nifi_node_count
}

resource "aws_network_interface_sg_attachment" "zookeeper_primary_security_group_attachment" {
  security_group_id    = aws_security_group.zookeeper.id
  network_interface_id = aws_instance.zookeeper[count.index].primary_network_interface_id
  count                = var.nifi_zookeeper_count
}

resource "aws_network_interface_sg_attachment" "all_zookeeper_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.zookeeper[count.index].primary_network_interface_id
  count                = var.nifi_zookeeper_count
}

