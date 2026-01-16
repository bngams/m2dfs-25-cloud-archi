// New approach: mysql.tf

# Example mysql.tf for WordPress stack
resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_volume" "mysql_data" {
  name = "mysql_data"
}

resource "docker_container" "db" {
  name  = "wordpress_db"
  image = docker_image.mysql.image_id

  restart = "always"

  env = [
    "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
    "MYSQL_DATABASE=${var.mysql_database}",
    "MYSQL_USER=${var.mysql_user}",
    "MYSQL_PASSWORD=${var.mysql_password}"
  ]

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}
