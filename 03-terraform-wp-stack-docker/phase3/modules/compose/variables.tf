variable "containers" {
  description = "List of container definitions."
  type = list(object({
    name    = string
    image   = string
    restart = optional(string)
    env     = optional(list(string))
    ports   = optional(list(object({
      internal = number
      external = number
    })))
    volumes = optional(list(object({
      name           = string
      container_path = string
    })))
    networks = optional(list(object({
      name = string
    })))
  }))
}

variable "volumes" {
  description = "List of volumes to create."
  type = list(object({
    name = string
  }))
  default = []
}

variable "networks" {
  description = "List of networks to create."
  type = list(object({
    name = string
  }))
  default = []
}
