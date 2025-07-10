FROM python:3.10-slim

WORKDIR /app

# Installer cron, grep, etc.
RUN apt-get update && apt-get install -y \
    cron \
    grep \
    procps \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Installeur
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copier 
COPY . .

# droits initdb
RUN chmod +x /app/initdb/02_create_roles.sh
RUN chmod +x /app/initdb/04_set_encryption_key.sh

# Copier scripts SQL initdb
COPY initdb/04_set_encryption_key.sh /docker-entrypoint-initdb.d/
COPY initdb/01_prepare_encryption_key.sql /docker-entrypoint-initdb.d/
COPY initdb/05_create_encryption_triggers.sql /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/04_set_encryption_key.sh

# droits
RUN chmod +x /app/wait-for-postgres.sh
RUN chmod +x /app/entrypoint.sh

# log cron
RUN touch /var/log/cron.log

# crontab
RUN crontab /app/crontab.txt

# Prometheus
EXPOSE 8000


CMD ["/bin/sh", "-c", "/app/entrypoint.sh"]

