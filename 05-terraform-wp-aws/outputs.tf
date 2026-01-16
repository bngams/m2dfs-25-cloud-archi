output "ec2_public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.wordpress.public_ip
}

output "wordpress_url" {
  description = "URL d'accès à WordPress"
  value       = "http://${aws_instance.wordpress.public_ip}"
}

output "rds_endpoint" {
  description = "Endpoint de la base de données"
  value       = aws_db_instance.wordpress.endpoint
  sensitive   = true
}
