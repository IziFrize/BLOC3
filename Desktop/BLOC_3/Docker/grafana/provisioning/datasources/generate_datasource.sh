#!/bin/sh

echo "Substitution de la variable d'environnement dans le fichier YAML..."


envsubst '${POSTGRES_PASSWORD}' < /etc/grafana/provisioning/datasources/datasource-template.yaml > /etc/grafana/provisioning/datasources/datasource.yaml

echo "Fichier datasource.yaml généré."


/run.sh
