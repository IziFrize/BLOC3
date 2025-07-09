FROM python:3.10-slim

WORKDIR /app

# Installer cron, grep, etc.
RUN apt-get update && apt-get install -y \
    cron \
    grep \
    procps \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Installer les dépendances Python
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copier tout le contenu du projet
COPY . .

# Donner les bons droits aux scripts initdb
RUN chmod +x /app/initdb/02_create_roles.sh
RUN chmod +x /app/initdb/04_set_encryption_key.sh


# 👉 Copier 04_set_encryption_key.sh au bon endroit pour PostgreSQL
COPY initdb/04_set_encryption_key.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/04_set_encryption_key.sh

# 👉 Ajouter les triggers d’encryption auto
COPY initdb/01_prepare_encryption_key.sql /docker-entrypoint-initdb.d/
COPY initdb/05_create_encryption_triggers.sql /docker-entrypoint-initdb.d/

# Donner les droits d'exécution aux scripts de démarrage
RUN chmod +x /app/wait-for-postgres.sh
RUN chmod +x /app/entrypoint.sh

# Créer le fichier de log pour cron
RUN touch /var/log/cron.log

# Charger le crontab
RUN crontab /app/crontab.txt

# Lancer le script Python après que PostgreSQL soit prêt, puis démarrer cron
ENTRYPOINT ["/app/entrypoint.sh"]
