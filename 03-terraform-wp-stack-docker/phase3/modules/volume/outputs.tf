output "volume_name" {
  description = "The name of the Docker volume."
  value       = docker_volume.this.name
}

output "volume_id" {
  description = "The ID of the Docker volume."
  value       = docker_volume.this.id
}
