# TODO - Déploiement WordPress sur AWS avec Terraform (Version Simplifiée)

## Architecture Simple

- 1 instance EC2 dans un sous-réseau public
- 1 instance RDS MySQL dans un sous-réseau privé
- Pas de Load Balancer, pas d'EFS
- Accès direct via l'IP publique de l'EC2

---

## Structure des fichiers Terraform

### 1. `provider.tf`
Configuration du provider AWS
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

### 2. `variables.tf`
Définir les variables suivantes :
- `aws_region` : Région AWS (ex: eu-west-3)
- `vpc_cidr` : CIDR du VPC (ex: 10.0.0.0/16)
- `public_subnet_cidr` : CIDR public (ex: 10.0.1.0/24)
- `private_subnet_cidr` : CIDR privé (ex: 10.0.2.0/24)
- `availability_zone` : Zone de disponibilité (ex: eu-west-3a)
- `db_name` : Nom de la base de données WordPress
- `db_username` : Utilisateur DB (**À COMPLÉTER**)
- `db_password` : Mot de passe DB (**À COMPLÉTER** - utiliser `sensitive = true`)
- `instance_type` : Type d'instance EC2 (ex: t3.micro)
- `ami_id` : AMI Amazon Linux 2023 (**À COMPLÉTER** selon la région)
- `my_ip` : Votre IP pour SSH (**À COMPLÉTER** ex: "x.x.x.x/32")

**💡 Conseil** : Pour les informations sensibles (db_password), utiliser `terraform.tfvars` (ne pas commiter)

### 3. `vpc.tf`
Créer les ressources réseau :
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "wordpress-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wordpress-igw"
  }
}

# Sous-réseau public (pour EC2)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "wordpress-public-subnet"
  }
}

# Sous-réseau privé (pour RDS)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "wordpress-private-subnet"
  }
}
```

### 4. `route_table.tf`
Configurer le routage :
```hcl
# Table de routage publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "wordpress-public-rt"
  }
}

# Association du sous-réseau public
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

### 5. `security_group.tf`
Définir les groupes de sécurité :

**SG pour EC2 :**
```hcl
resource "aws_security_group" "ec2" {
  name        = "wordpress-ec2-sg"
  description = "Security group for WordPress EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]  # À COMPLÉTER dans variables
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-ec2-sg"
  }
}
```

**SG pour RDS :**
```hcl
resource "aws_security_group" "rds" {
  name        = "wordpress-rds-sg"
  description = "Security group for WordPress RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-rds-sg"
  }
}
```

### 6. `rds.tf`
Base de données MySQL :
```hcl
# Subnet Group pour RDS (nécessite au moins 2 subnets dans 2 AZs différentes)
resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-db-subnet"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_2.id]

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

# Sous-réseau privé supplémentaire pour RDS (requis par AWS)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"  # À ajuster selon votre VPC CIDR
  availability_zone = "eu-west-3b"   # À COMPLÉTER : AZ différente de la première

  tags = {
    Name = "wordpress-private-subnet-2"
  }
}

# Instance RDS
resource "aws_db_instance" "wordpress" {
  identifier             = "wordpress-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "wordpress-db"
  }
}
```

### 7. `ec2.tf`
Instance EC2 unique avec user data pour installer WordPress :
```hcl
resource "aws_instance" "wordpress" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    db_endpoint = aws_db_instance.wordpress.endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = {
    Name = "wordpress-server"
  }

  depends_on = [aws_db_instance.wordpress]
}
```

### 8. `user_data.sh`
Script d'initialisation EC2 (**À CRÉER**) :
```bash
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
```

### 9. `outputs.tf`
Afficher les informations importantes :
```hcl
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
```

---

## Étapes de déploiement

1. **Initialiser Terraform**
   ```bash
   terraform init
   ```

2. **Créer le fichier terraform.tfvars** (**À FAIRE**)
   ```hcl
   aws_region = "eu-west-3"
   vpc_cidr = "10.0.0.0/16"
   public_subnet_cidr = "10.0.1.0/24"
   private_subnet_cidr = "10.0.2.0/24"
   availability_zone = "eu-west-3a"

   db_name = "wordpress"
   db_username = "admin"
   db_password = "VotreMotDePasseSecurise123!"

   instance_type = "t2.micro"
   ami_id = "ami-xxxxxxxxx"  # AMI Amazon Linux 2023 pour eu-west-3
   my_ip = "x.x.x.x/32"       # Votre IP publique
   ```

3. **Valider la configuration**
   ```bash
   terraform validate
   ```

4. **Planifier le déploiement**
   ```bash
   terraform plan
   ```

5. **Appliquer la configuration**
   ```bash
   terraform apply
   ```

6. **Accéder à WordPress**
   - Récupérer l'IP publique de l'EC2 dans les outputs
   - Ouvrir `http://<IP_PUBLIQUE>` dans un navigateur
   - Compléter l'installation WordPress (langue, admin, etc.)

---

## Points à compléter vous-même

- [ ] Variables sensibles dans `variables.tf` et `terraform.tfvars` (db_password, my_ip, ami_id)
- [ ] AMI ID approprié pour votre région AWS (chercher "Amazon Linux 2023" dans la console)
- [ ] Deuxième zone de disponibilité pour le subnet privé RDS
- [ ] Script `user_data.sh` complet (optionnel, une base est fournie)
- [ ] Tags personnalisés si nécessaire

---

## Améliorations possibles (pour aller plus loin)

- Application Load Balancer + plusieurs instances EC2
- Auto Scaling Group pour la scalabilité
- EFS pour partager les fichiers entre instances
- ACM (AWS Certificate Manager) pour HTTPS
- Route 53 pour un nom de domaine personnalisé
- CloudWatch pour le monitoring
- Secrets Manager pour les credentials
- Multi-AZ pour RDS (haute disponibilité)

---

## Nettoyage

Pour supprimer toutes les ressources :
```bash
terraform destroy
```

**⚠️ Attention** : Cela supprimera toutes les ressources créées, y compris la base de données !
