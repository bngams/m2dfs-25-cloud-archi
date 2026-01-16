resource "docker_image" "ubuntu_resolute" {
  name = "ubuntu:resolute"
}

resource "docker_container" "ubuntu_resolute_container" {
    name  = "ubuntu_resolute_container"
    image = docker_image.ubuntu_resolute.image_id
    command = [ "sleep", "infinity" ]
}