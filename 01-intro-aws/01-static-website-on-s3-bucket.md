# 🚀 Hébergement d’un site Web statique avec Amazon S3

## 🎯 Objectifs pédagogiques

À la fin de ce module, vous serez capables de :

* Comprendre le service Amazon S3 et son usage comme hébergement statique simple.
* Configurer les règles d'accès : Bucket Policies, ACL, Block Public Access, OAC, etc.
* Identifier les composants AWS liés à un site web statique :

  * 🌐 Amazon Route 53 (DNS)
  * 🚀 Amazon CloudFront (CDN / optimisation / HTTPS)
  * 🔐 AWS Certificate Manager (certificats TLS)
* Comparer S3 avec d’autres solutions frontend sur AWS, comme AWS Amplify Hosting.

---

## 🏗️ Les différentes façons d’héberger un site statique sur AWS

AWS propose plusieurs services pour déployer un site statique (HTML/CSS/JS, SPA, fichiers statiques) :

### ✔️ 1. Amazon S3

La solution la plus simple : un bucket public servant un site statique depuis un endpoint HTTP.

### ✔️ 2. Amazon S3 + CloudFront (recommandé)

⚡ Plus rapide, plus sécurisé, HTTPS, cache CDN, intégration avec ACM.

### ✔️ 3. AWS Amplify Hosting

Solution moderne pour les sites complexes (SPA, SSR, SSG) avec CI/CD intégré.

---

## 🟦 Scénario 1 : Hébergement simple avec Amazon S3

**🎯 Objectif :** Déployer un site statique simple directement via un bucket S3.
C’est l’approche de base proposée dans la documentation officielle.

### 🗺️ Architecture (version simple avec S3)

```
architecture-beta
    group aws_cloud(aws:aws-cloud)[AWS Cloud]
        service s3_bucket(aws:arch-amazon-simple-storage-service)[S3 Website Bucket] in aws_cloud
        service bucket_policy(aws:arch-bucket-policy)[Bucket Policy] in aws_cloud
        service bucket_acl(aws:arch-bucket-acl)[Bucket ACL] in aws_cloud
        service cloudfront(aws:arch-amazon-cloudfront)[CloudFront CDN] in aws_cloud
        service route53(aws:arch-amazon-route-53)[Route 53 DNS] in aws_cloud
        service cert_manager(aws:arch-aws-certificate-manager)[Certificate Manager] in aws_cloud

    service user(aws:res-user)[User]

    bucket_policy:L --> R:s3_bucket
    bucket_acl:L --> R:s3_bucket

    user:R --> L:route53
    route53:B --> T:cloudfront
    cloudfront:R --> L:s3_bucket
    cert_manager:T -- B:cloudfront
```

---

## 🧱 Analyse du scénario S3 simple

### 📌 Avantages :

* Très économique
* Simple à mettre en place
* Parfait pour un site statique sans contrainte HTTPS stricte

### 📌 Inconvénients :

* ❌ Pas de HTTPS (S3 website endpoint = HTTP only)
* ❌ Bucket public obligatoire
* ❌ Moins bon en performance sans CloudFront

### 📌 Situations d’usage :

* Démo simple
* Portfolio
* Site de documentation interne
* POC / projets étudiants

---

## 🟧 Aperçu détaillé de l’architecture complète (S3 + CloudFront recommandé)

```
flowchart LR

subgraph DNS_TLS[DNS & TLS Layer]
    DNS[Route53 DNS]
    ACM[ACM Certificate]
end

subgraph CDN[CDN Layer - CloudFront]
    CloudFront[CloudFront Distribution]
    WAF[AWS WAF Firewall]
end

subgraph S3_WEBSITE[S3 Website Bucket - Public]
    S3_Bucket_Web[S3 Bucket - Website Endpoint]
    Index[Index.html & Error.html]
    BucketPolicyPublic[Bucket Policy - Public Read]
end

subgraph S3_PRIVATE[S3 Private Bucket for CloudFront]
    S3_Bucket_Private[S3 Bucket - Private Origin]
    Index2[Index.html & Error.html]
    BucketPolicyCF[Bucket Policy - Allow CloudFront OAC]
    ObjectOwnership[Object Ownership - BucketOwnerEnforced]
    Encryption[SSE-S3 or SSE-KMS]
end

subgraph LOGS[Logging & Monitoring]
    LogsS3[Access Logs]
    LogsBucket[S3 Logs Bucket]
    Monitoring[CloudWatch Metrics & Alarms]
end

subgraph CICD[CI/CD Pipeline]
    CI[CI/CD GitHub Actions, CodePipeline]
end

DNS -->|Alias| CloudFront
DNS -->|Alias apex| S3_Bucket_Web
ACM --> CloudFront

CloudFront -->|Origin OAC| S3_Bucket_Private
CloudFront -->|Origin Website endpoint| S3_Bucket_Web

WAF --> CloudFront

S3_Bucket_Web --- Index
S3_Bucket_Private --- Index2

S3_Bucket_Web --> BucketPolicyPublic
S3_Bucket_Private --> BucketPolicyCF

S3_Bucket_Private --> ObjectOwnership
S3_Bucket_Private --> Encryption
S3_Bucket_Web --> Encryption

CloudFront --> LogsS3
S3_Bucket_Web --> LogsS3
LogsS3 --> LogsBucket

Monitoring --> CloudFront
Monitoring --> S3_Bucket_Web

CI -->|Deploy files| S3_Bucket_Web
CI -->|Invalidate cache| CloudFront

RedirectBucket[S3 Redirect Bucket www → apex] --> DNS
RedirectBucket --> S3_Bucket_Web
```

## 📚 🧑‍🏫 Explications pour les étudiants (avec icônes AWS en texte)

| Composant                       | Rôle                                    | Icône |
| ------------------------------- | --------------------------------------- | ----- |
| **Amazon S3**                   | Stockage d’objets, hébergement statique | 📦    |
| **Bucket Policy**               | Règles d’accès JSON                     | 🔐    |
| **ACL**                         | Ancien mécanisme d’accès (à éviter)     | ⚠️    |
| **CloudFront**                  | CDN, HTTPS, cache                       | 🚀    |
| **Route 53**                    | DNS managé                              | 🌐    |
| **ACM**                         | Certificats TLS gratuits                | 🔏    |
| **CloudWatch**                  | Logs & Monitoring                       | 📊    |
| **AWS WAF**                     | Protection Web                          | 🛡️   |
| **CI/CD (GitHub/CodePipeline)** | Automatisation du déploiement           | 🤖    |

---

## 🚀 Aller plus loin

Pour des applications plus complexes (React, Vue, Next.js, Angular, SSR, SSG, SPA), ou si vous voulez déployer automatiquement depuis un dépôt GitHub :

👉 **AWS Amplify Hosting**
[https://aws.amazon.com/fr/amplify/](https://aws.amazon.com/fr/amplify/)

### 📌 Avantages :

* Build & deploy automatiques
* HTTPS intégré
* Prévisualisation des PR
* Gestion de plusieurs environnements (dev/stage/prod)
* Support SSR/SSG pour Next.js

### 🖼️ Schéma officiel (Amplify)

![AWS Amplify Architecture](https://d1.awsstatic.com/onedam/marketing-channels/website/aws/en_US/product-categories/frontend-web-mobile/approved/images/7361d2c9-01e3-4e25-86ca-cb4591c069c2.bee7ede0dd142cad72cdf5f9c5494dc139f2ea4a.png)
