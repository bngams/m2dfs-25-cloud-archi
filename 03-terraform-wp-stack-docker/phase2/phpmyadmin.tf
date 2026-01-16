// New approach: phpmyadmin.tf

# Example phpmyadmin.tf for WordPress stack
resource "docker_image" "phpmyadmin" {
  name = "phpmyadmin/phpmyadmin:latest"
}

resource "docker_container" "phpmyadmin" {
  name  = "wordpress_pma"
  image = docker_image.phpmyadmin.image_id

  restart = "always"

  depends_on = [docker_container.db]

  env = [
    "PMA_HOST=wordpress_db",
    "PMA_USER=${var.mysql_user}",
    "PMA_PASSWORD=${var.mysql_password}"
  ]

  ports {
    internal = 80
    external = 8088
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}
