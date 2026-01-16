module "mysql_compose" {
  source = "./modules/compose"
  containers = [
    {
      name    = "wordpress_db"
      image   = "mysql:8.0"
      restart = "always"
      env = [
        "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
        "MYSQL_DATABASE=${var.mysql_database}",
        "MYSQL_USER=${var.mysql_user}",
        "MYSQL_PASSWORD=${var.mysql_password}"
      ]
      volumes = [
        {
          name           = "mysql_data"
          container_path = "/var/lib/mysql"
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
    { name = "mysql_data" }
  ]
  networks = [
    { name = "wordpress_network" }
  ]
}