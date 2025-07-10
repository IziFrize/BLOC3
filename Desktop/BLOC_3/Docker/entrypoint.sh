#!/bin/bash
set -e

echo "Attente de PostgreSQL..."
/app/wait-for-postgres.sh

echo "Vérification de la présence de la clé côté PostgreSQL..."
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DB_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT current_setting('app.encryption_key', true);" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Clé détectée et active dans PostgreSQL."
else
  echo "❌ Clé manquante ou non accessible."
  exit 1
fi

echo "Insertion initiale des données..."
python /app/insert_data.py

echo "Lancement de cron..."
cron -f
