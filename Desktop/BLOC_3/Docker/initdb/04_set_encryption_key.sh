#!/bin/bash

echo "Configuration de la clé de chiffrement dans PostgreSQL..."

psql -U admin -d smartretail <<EOF
-- Définir la variable de chiffrement au niveau du rôle
ALTER ROLE admin SET app.encryption_key = '${ENCRYPTION_KEY}';
EOF
