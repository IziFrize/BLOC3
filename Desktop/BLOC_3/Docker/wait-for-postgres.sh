#!/bin/bash

# Attente que PostgreSQL soit prêt
until pg_isready -h "$DB_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" > /dev/null 2>&1; do
  echo "⏳ PostgreSQL non prêt — attente..."
  sleep 1
done

echo "✅ PostgreSQL est prêt."
