output "nifi_node_security_group" {
  value = aws_security_group.nifi_nodes.id
}

output "nifi_all_security_group" {
  value = aws_security_group.all.id
}

output "nifi_zookeeper_security_group" {
  value = aws_security_group.nifi_zookeeper.id
}
