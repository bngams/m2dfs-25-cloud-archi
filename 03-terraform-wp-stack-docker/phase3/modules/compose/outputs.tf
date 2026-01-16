output "container_names" {
  value = [for c in docker_container.this : c.name]
}

output "volume_names" {
  value = [for v in docker_volume.this : v.name]
}

output "network_names" {
  value = [for n in docker_network.this : n.name]
}
