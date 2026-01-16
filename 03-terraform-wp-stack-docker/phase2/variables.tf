// New approach: variables.tf

# Example variables.tf for WordPress stack
variable "mysql_root_password" {
  description = "Root password for MySQL."
  type        = string
  default     = "MySQLRootPassword"
}

variable "mysql_database" {
  description = "Database name for WordPress."
  type        = string
  default     = "wordpress"
}

variable "mysql_user" {
  description = "MySQL user for WordPress."
  type        = string
  default     = "wp_user"
}

variable "mysql_password" {
  description = "Password for MySQL user."
  type        = string
  default     = "wp_password"
}

variable "wp_port" {
  description = "External port for WordPress."
  type        = number
  default     = 80
}