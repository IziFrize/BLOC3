# 🛍️ SmartRetail Data Platform – Infrastructure Sécurisée & Observabilité

## 📌 Objectif

Ce projet simule une infrastructure **industrialisable** de gestion de données pour une entreprise de **retail intelligent**. Elle répond aux exigences de :

- **sécurité avancée (chiffrement RGPD)**,
- **supervision technique (Prometheus + Grafana)**,
- **automatisation du pipeline (injection + cron)**,
- **résilience et évolutivité cloud-ready**.

---

## 🧱 Architecture du projet

```
SmartRetail/
├── data/                        # Données brutes (CSV)
├── initdb/                      # Scripts SQL/Bash init (crypto, rôles, triggers)
├── grafana/                     # Dashboards et provisioning
├── prometheus/                  # Configuration Prometheus
├── insert_data.py              # Insertion chiffrée des données
├── metrics.py                  # Définition centralisée des métriques
├── Dockerfile                  # Build de l'image app
├── docker-compose.yml          # Orchestration des services
├── .env                        # Variables d’environnement sensibles
├── crontab.txt                 # Planification de l'injection via cron
├── entrypoint.sh               # Lancement auto de l'app
├── wait-for-postgres.sh        # Attente active de PostgreSQL
└── README.md                   # ➡️ (ce fichier)
```

---

## 🔐 Sécurité & Conformité

- **Chiffrement symétrique (pgcrypto + AES-256)** sur toutes les données sensibles.
- **Clé d’encryption injectée** par variable d’environnement (`ENCRYPTION_KEY`) et appliquée au rôle `admin`.
- **Triggers automatiques** pour crypter lors des `INSERT`/`UPDATE`.
- **Vues SQL déchiffrées** accessibles uniquement aux rôles autorisés (`v_clients_decrypted`, etc.).
- **Gestion des rôles** : `admin`, `app_user`, `writer`, `analyst`.

---

## 🔁 Pipeline de Données

1. **CSV** → lu avec Pandas.
2. **Insertion dans PostgreSQL** via `insert_data.py`.
3. **Chiffrement automatique** via triggers.
4. **Supervision de l’injection** via Prometheus.

---

## 📊 Supervision & Observabilité

- `metrics.py` expose les métriques suivantes sur **port 8000** :
  - `smartretail_runs_total`
  - `smartretail_processing_duration_seconds`
  - `smartretail_errors_total`
  - `smartretail_last_insert_count`
- **Prometheus** scrappe ces métriques.
- **Grafana** (auto-provisionné) visualise les performances métier et système.

---

## ▶️ Lancer la plateforme

```bash
docker-compose up --build
```

Cela :
- construit l’image de l’application,
- initialise la base PostgreSQL (roles, clés, triggers, vues),
- insère les données chiffrées,
- expose les métriques,
- active le monitoring (Grafana + Prometheus).

---

## 🧪 Interagir avec PostgreSQL

```bash
docker exec -it smartretail_db psql -U admin -d smartretail
```

**Exemples** :

```sql
-- Voir les données chiffrées :
SELECT * FROM clients LIMIT 5;

-- Voir les données déchiffrées :
SELECT * FROM v_clients_decrypted LIMIT 5;
```

---

## 🧬 Métriques & Cron

Le job cron relance périodiquement `insert_data.py` :

```bash
docker exec -it smartretail_app tail -f /var/log/cron.log
```

---

## 📈 Accès Grafana

- URL : `http://localhost:3000`
- Login par défaut : `admin` / `admin` (modifiable)
- Datasources :
  - PostgreSQL (données déchiffrées)
  - Prometheus (métriques système + app)

---

## ✅ Fonctionnalités réalisées

- [x] Déploiement orchestré (Docker Compose)
- [x] Sécurisation RGPD par chiffrement + rôles
- [x] Ingestion automatique des données
- [x] Supervision complète
- [x] Observabilité en temps réel via Prometheus + Grafana

---

## 💡 Améliorations possibles

- 🔔 Ajout d’un **système d’alertes Prometheus**
- 📉 Calcul d’indicateurs métiers (chiffre d’affaires, fréquentation…)
- ☁️ Déploiement sur AWS avec `EC2 + RDS + EFS`
- 🔄 API REST en front de la base (FastAPI ?)

---

## 👨‍🏫 Contexte pédagogique

Ce projet a été réalisé dans le cadre du bloc **"Industrialisation et maintenance de solution data"** de la certification **Data Engineer – RNCP 37624**.
