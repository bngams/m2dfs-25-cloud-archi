resource "docker_network" "this" {
  for_each = { for n in var.networks : n.name => n }
  name     = each.value.name
}

resource "docker_volume" "this" {
  for_each = { for v in var.volumes : v.name => v }
  name     = each.value.name
}

resource "docker_container" "this" {
  for_each = { for c in var.containers : c.name => c }
  name     = each.value.name
  image    = each.value.image
  restart  = lookup(each.value, "restart", null)
  env      = lookup(each.value, "env", null)

  dynamic "ports" {
    for_each = lookup(each.value, "ports", [])
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  dynamic "volumes" {
    for_each = lookup(each.value, "volumes", [])
    content {
      volume_name    = docker_volume.this[volumes.value.name].name
      container_path = volumes.value.container_path
    }
  }

  dynamic "networks_advanced" {
    for_each = lookup(each.value, "networks", [])
    content {
      name = docker_network.this[networks_advanced.value.name].name
    }
  }
}
