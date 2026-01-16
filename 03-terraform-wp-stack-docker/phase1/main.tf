# =============================================================================
# IMAGES
# =============================================================================
resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

resource "docker_image" "phpmyadmin" {
  name = "phpmyadmin/phpmyadmin:latest"
}

# =============================================================================
# NETWORK
# =============================================================================
resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}

# =============================================================================
# VOLUMES
# =============================================================================
resource "docker_volume" "mysql_data" {
  name = "mysql_data"
}

resource "docker_volume" "wordpress_data" {
  name = "wordpress_data"
}

# =============================================================================
# CONTAINERS
# =============================================================================

# --- MySQL ---
resource "docker_container" "db" {
  name  = "wordpress_db"
  image = docker_image.mysql.image_id

  restart = "always"

  env = [
    "MYSQL_ROOT_PASSWORD=MySQLRootPassword",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wp_user",
    "MYSQL_PASSWORD=wp_password"
  ]

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}

# --- WordPress ---
resource "docker_container" "wordpress" {
  name  = "wordpress_app"
  image = docker_image.wordpress.image_id

  restart = "always"

  depends_on = [docker_container.db]

  env = [
    "WORDPRESS_DB_HOST=wordpress_db:3306",
    "WORDPRESS_DB_USER=wp_user",
    "WORDPRESS_DB_PASSWORD=wp_password",
    "WORDPRESS_DB_NAME=wordpress"
  ]

  ports {
    internal = 80
    external = 8000
  }

  volumes {
    volume_name    = docker_volume.wordpress_data.name
    container_path = "/var/www/html"
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}

# --- phpMyAdmin ---
resource "docker_container" "phpmyadmin" {
  name  = "wordpress_pma"
  image = docker_image.phpmyadmin.image_id

  restart = "always"

  depends_on = [docker_container.db]

  env = [
    "PMA_HOST=wordpress_db",
    "PMA_USER=wp_user",
    "PMA_PASSWORD=wp_password"
  ]

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}