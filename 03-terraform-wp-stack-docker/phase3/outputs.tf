output "mysql_container_names" {
  value = module.mysql_compose.container_names
}

output "wordpress_container_names" {
  value = module.wordpress_compose.container_names
}

output "phpmyadmin_container_names" {
  value = module.phpmyadmin_compose.container_names
}

output "all_network_names" {
  value = distinct(
    concat(
      module.mysql_compose.network_names,
      module.wordpress_compose.network_names,
      module.phpmyadmin_compose.network_names
    )
  )
}

output "all_volume_names" {
  value = distinct(
    concat(
      module.mysql_compose.volume_names,
      module.wordpress_compose.volume_names,
      module.phpmyadmin_compose.volume_names
    )
  )
}