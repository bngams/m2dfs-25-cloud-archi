module "wordpress_compose" {
  source = "./modules/compose"
  containers = [
    {
      name    = "wordpress_app"
      image   = "wordpress:latest"
      restart = "always"
      env = [
        "WORDPRESS_DB_HOST=wordpress_db:3306",
        "WORDPRESS_DB_USER=${var.mysql_user}",
        "WORDPRESS_DB_PASSWORD=${var.mysql_password}",
        "WORDPRESS_DB_NAME=${var.mysql_database}"
      ]
      ports = [
        {
          internal = 80
          external = var.wp_port
        }
      ]
      volumes = [
        {
          name           = "wordpress_data"
          container_path = "/var/www/html"
        }
      ]
      networks = [
        {
          name = "wordpress_network"
        }
      ]
    }
  ]
  volumes = [
    { name = "wordpress_data" }
  ]
  networks = [
    { name = "wordpress_network" }
  ]
}