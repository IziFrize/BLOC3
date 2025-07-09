# 🛍️ SmartRetail Data Platform (Dockerized)

## 📌 Objectif
Ce projet simule une infrastructure de données pour un environnement de **retail intelligent**. Il charge automatiquement des données sensibles **chiffrées** dans PostgreSQL à l'aide de conteneurs Docker, puis crée des **vues déchiffrées sécurisées** prêtes à être utilisées dans des outils comme **Grafana**.

---

## 📁 Structure du projet

```
SmartRetail/
├── data/                           # Fichiers CSV bruts (non chiffrés)
│   ├── Clients.csv
│   ├── Cartes_de_Fid_lit_.csv
│   ├── ...
├── initdb/                         # Scripts d'initialisation SQL & bash
│   ├── 00_create_schema.sql        # Création des tables
│   ├── 01_prepare_encryption_key.sql  # Fonctions SQL de chiffrement/déchiffrement
│   ├── 02_create_roles.sh          # Création des rôles
│   ├── 03_create_decryption_views.sql  # Vues déchiffrées
│   ├── 04_set_encryption_key.sh    # Applique la clé au rôle
│   ├── 05_create_encryption_triggers.sql # Triggers de chiffrement automatique
├── insert_data.py                 # Script Python d’insertion des données
├── Dockerfile                     # Image app Python (cron + client PostgreSQL)
├── docker-compose.yml             # Démarrage des services
├── entrypoint.sh                  # Exécution des tâches (insert + cron)
├── crontab.txt                    # Planification de l’insertion (cron)
├── requirements.txt               # Dépendances Python
├── .gitignore
├── .env                           # Contient la clé `ENCRYPTION_KEY`
└── README.md
```

---

## 🔐 Sécurité des données

- **Chiffrement :** Toutes les colonnes sensibles (nom, email, etc.) sont chiffrées avec `pgcrypto` (AES-256).
- **Clé unique** définie via la variable `ENCRYPTION_KEY` (dans `.env`) puis injectée dans PostgreSQL (`ALTER ROLE ... SET app.encryption_key`).
- **Chiffrement automatique** : des *triggers SQL* encryptent chaque champ sensible à l’insertion.
- **Vues sécurisées** : des vues `v_<table>_decrypted` permettent aux utilisateurs autorisés d’accéder aux données en clair (lecture seule).

---

## 🧪 Exécution locale

### 📦 Lancer la plateforme :

```bash
docker-compose up --build
```

Ce que fait cette commande :
1. Construit l'image Python avec `cron` + `psql`
2. Crée la base PostgreSQL et le schéma
3. Active les fonctions et triggers de chiffrement
4. Applique la clé de chiffrement
5. Insère les données automatiquement

---

### 🛠️ Accès à la base PostgreSQL

```bash
docker exec -it smartretail_db psql -U admin -d smartretail
```

Puis, par exemple :

```sql
-- Voir les données chiffrées :
SELECT * FROM clients LIMIT 5;

-- Voir les données déchiffrées :
SELECT * FROM v_clients_decrypted LIMIT 5;
```

---

## 🔁 Insertion automatique avec Cron

Le conteneur Python lance périodiquement `insert_data.py` selon le `crontab.txt`. Tu peux voir les logs de cron avec :

```bash
docker exec -it smartretail_app tail -f /var/log/cron.log
```

---

## 🔎 Triggers PostgreSQL actifs

Les `triggers` encryptent les colonnes sensibles **à chaque INSERT**, par exemple :

```sql
CREATE TRIGGER encrypt_clients
BEFORE INSERT ON clients
FOR EACH ROW
EXECUTE FUNCTION encrypt_clients_columns();
```

---

## 📈 À venir : intégration Grafana

Tu pourras :
- Connecter Grafana à PostgreSQL (port 5432)
- Lire directement les vues `v_*_decrypted`
- Construire des dashboards en clair, sans exposer les données brutes

---

## 🚧 Suggestions d'amélioration

- ✅ Ajouter une **table `logs`** pour tracer les insertions
- 📅 Ajouter la **date d’exécution** dans les données
- 📊 Créer des dashboards Grafana par table
- 🔐 Gestion des droits par rôle (lecture seule pour Grafana)

---

## 🧰 Dépannage rapide

### Nettoyer l’environnement :

```bash
docker-compose down -v
docker system prune -af
docker volume prune -f
```

### Relancer proprement :

```bash
docker-compose up --build
```

---

## 👨‍💻 Auteurs

Projet réalisé dans le cadre du module **Sécurité & Données (B3)**.  
Encadré par l’équipe pédagogique.

---
