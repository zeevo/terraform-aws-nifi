resource "aws_key_pair" "ssh_key" {
  key_name   = var.KEY_NAME
  public_key = var.PUBLIC_KEY
}

resource "aws_instance" "node" {
  ami           = "ami-058bd2d568351da34"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "nifi-${count.index}"
    Role = "nifi"
  }
  count = 2
  root_block_device {
    volume_size = 20
  }
}

resource "aws_instance" "zookeeper" {
  ami           = "ami-058bd2d568351da34"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "zookeeper"
    Role = "zookeeper"
  }
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
      description      = "Zookeeper"
      from_port        = 2181
      to_port          = 2181
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
  count                = 2
}

resource "aws_network_interface_sg_attachment" "all_nodes_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.node[count.index].primary_network_interface_id
  count                = 2
}

resource "aws_network_interface_sg_attachment" "zookeeper_primary_security_group_attachment" {
  security_group_id    = aws_security_group.zookeeper.id
  network_interface_id = aws_instance.zookeeper.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "all_zookeeper_security_group_attachement" {
  security_group_id    = aws_security_group.all.id
  network_interface_id = aws_instance.zookeeper.primary_network_interface_id
}

