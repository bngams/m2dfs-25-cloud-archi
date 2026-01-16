// New approach: network.tf

# Example network.tf for WordPress stack
resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}
