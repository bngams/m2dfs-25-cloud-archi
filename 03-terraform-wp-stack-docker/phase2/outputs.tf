// New approach: outputs.tf

# Example outputs.tf for WordPress stack
output "wordpress_container_name" {
  description = "Name of the WordPress container."
  value       = docker_container.wordpress.name
}

output "phpmyadmin_container_name" {
  description = "Name of the phpMyAdmin container."
  value       = docker_container.phpmyadmin.name
}
