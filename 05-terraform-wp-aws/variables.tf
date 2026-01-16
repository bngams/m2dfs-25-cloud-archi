variable "aws_region" {
    description = "The AWS region."
    type        = string
}

variable "aws_access_key" {
    description = "The AWS access key."
    type        = string
}

variable "aws_secret_key" {
    description = "The AWS secret access key."
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR block for public subnet"
    type        = string
    default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR block for private subnet"
    type        = string
    default     = "10.0.2.0/24"
}

variable "availability_zone" {
    description = "Availability zone for subnets"
    type        = string
    default     = "eu-west-3a"
}

variable "db_name" {
    description = "WordPress database name"
    type        = string
    default     = "wordpress"
}

variable "db_username" {
    description = "Database username"
    type        = string
}

variable "db_password" {
    description = "Database password"
    type        = string
    sensitive   = true
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "ami_id" {
    description = "AMI ID for EC2 instance (Amazon Linux 2023)"
    type        = string
}

variable "my_ip" {
    description = "Your IP address for SSH access (CIDR notation)"
    type        = string
}