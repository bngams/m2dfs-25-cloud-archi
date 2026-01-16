#!/bin/bash
# Installation automatique de WordPress

# Mise à jour du système
yum update -y

# Installation Apache, PHP, MySQL client
yum install -y httpd php php-mysqlnd wget

# Installer WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

# Configurer wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/g" wp-config.php
sed -i "s/username_here/${db_username}/g" wp-config.php
sed -i "s/password_here/${db_password}/g" wp-config.php
sed -i "s/localhost/${db_endpoint}/g" wp-config.php

# Permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Démarrer Apache
systemctl start httpd
systemctl enable httpd
