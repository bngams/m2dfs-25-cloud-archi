module "phpmyadmin_compose" {
  source = "./modules/compose"
  containers = [
    {
      name    = "wordpress_pma"
      image   = "phpmyadmin/phpmyadmin:latest"
      restart = "always"
      env = [
        "PMA_HOST=wordpress_db",
        "PMA_USER=${var.mysql_user}",
        "PMA_PASSWORD=${var.mysql_password}"
      ]
      ports = [
        {
          internal = 80
          external = 8088
        }
      ]
      networks = [
        {
          name = "wordpress_network"
        }
      ]
    }
  ]
  networks = [
    { name = "wordpress_network" }
  ]
}