// New approach: wordpress.tf

# Example wordpress.tf for WordPress stack
resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

resource "docker_volume" "wordpress_data" {
  name = "wordpress_data"
}

resource "docker_container" "wordpress" {
  name  = "wordpress_app"
  image = docker_image.wordpress.image_id

  restart = "always"

  depends_on = [docker_container.db]

  env = [
    "WORDPRESS_DB_HOST=wordpress_db:3306",
    "WORDPRESS_DB_USER=${var.mysql_user}",
    "WORDPRESS_DB_PASSWORD=${var.mysql_password}",
    "WORDPRESS_DB_NAME=${var.mysql_database}"
  ]

  ports {
    internal = 80
    external = var.wp_port
  }

  volumes {
    volume_name    = docker_volume.wordpress_data.name
    container_path = "/var/www/html"
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}
