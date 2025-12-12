# 🚀 Introduction à Amazon EC2

## 🎯 Objectifs pédagogiques

À la fin de ce module, vous serez capables de :

* Comprendre le principe et le fonctionnement des instances Amazon EC2.
* Connaître les principaux composants nécessaires à la création d’une instance EC2.
* Configurer une instance EC2 de base avec une AMI, un type d’instance, une clé SSH, un VPC et des règles de sécurité.
* Installer un serveur web Apache et déployer un site statique sur votre instance EC2.

---

## 🏗️ Qu’est-ce qu’Amazon EC2 ?

Amazon Elastic Compute Cloud (EC2) est un service qui fournit des serveurs virtuels dans le cloud pour exécuter vos applications. Les utilisateurs peuvent lancer et gérer des instances de serveurs avec différentes configurations matérielles et logicielles.

### 🔹 Principes de fonctionnement

* **AMI (Amazon Machine Image)** : image système préconfigurée pour démarrer l’instance.
* **Type d’instance** : configuration de CPU, RAM, stockage et réseau.
* **Clé SSH** : pour se connecter de manière sécurisée à l’instance.
* **VPC (Virtual Private Cloud)** : réseau virtuel isolé pour vos instances.
* **Groupes de sécurité** : règles de firewall pour autoriser ou restreindre le trafic entrant/sortant.

---

## 💰 Options de facturation EC2

### 1️⃣ Instances à la demande

Les instances à la demande offrent une capacité de calcul facturée à l’utilisation à l’heure ou à la seconde. Aucun paiement initial ni engagement à long terme n’est requis.

**En savoir plus**

### 2️⃣ Savings Plan

Les Savings Plans peuvent vous aider à réduire votre facture de jusqu’à 72 % par rapport aux tarifs à la demande en échange d’un engagement d’utilisation.

**En savoir plus**

### 3️⃣ Instances Spot

Avec les instances Spot Amazon EC2, vous pouvez utiliser la capacité EC2 disponible dans le Cloud AWS à des tarifs réduits allant jusqu’à 90 % par rapport aux tarifs à la demande.

> ⚠️ Exemple pratique : pour une utilisation continue 24/7, EC2 n’est pas toujours le moins cher. Par exemple, un VPS classique chez OVH ou Scaleway :
>
> **Équivalent AWS EC2** : EC2 t3a.medium (approximation)
> À partir de ~31 € HT/mois (~37 € TTC/mois)
> 2 vCPU, 4 Go RAM, stockage EBS à ajouter
>
> **VPS-1 OVH**
> À partir de 3,82 € HT/mois (soit 4,58 € TTC/mois)
> 4 vCores, 8 Go RAM, 75 Go SSD

---

## 🖥️ Mise en pratique : créer une instance EC2

### Étapes principales

![Aperçu architecture EC2](/mnt/data/402a6e0a-8942-4fe5-abfb-995eb1f80f09.png)

1. **Choisir une AMI** : Ubuntu 20.04 LTS.
2. **Choisir un type d’instance** : t2.micro pour l’exemple.
3. **Configurer le réseau** : sélectionner un VPC et sous-réseau.
4. **Configurer le stockage** : ajouter un volume EBS si nécessaire.
5. **Configurer le groupe de sécurité** : ouvrir le port 22 (SSH) et 80 (HTTP).
6. **Générer ou utiliser une clé SSH** pour se connecter.
7. **Lancer l’instance** et récupérer son IP publique.

---

## 🌐 Installer Apache et déployer un site

Suivez ce tutoriel pour installer Apache et uploader un site statique sur Ubuntu 20.04 :

[https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04)

### Étapes résumées :

1. Se connecter à l’instance via SSH.
2. Mettre à jour les paquets : `sudo apt update && sudo apt upgrade`.
3. Installer Apache : `sudo apt install apache2`.
4. Vérifier que le serveur fonctionne : `sudo systemctl status apache2`.
5. Déployer votre site dans `/var/www/html/`.
6. Tester l’accès via le navigateur en utilisant l’IP publique de l’instance.

---

## ✅ Points clés à retenir

* EC2 est flexible, mais la facturation dépend du type d’utilisation.
* Les composants de base d’une instance EC2 sont l’AMI, le type d’instance, la clé SSH, le VPC et le groupe de sécurité.
* Apache peut être facilement installé pour héberger des sites statiques ou dynamiques.
* Comparer les options EC2 avec des VPS classiques est essentiel pour optimiser les coûts.
