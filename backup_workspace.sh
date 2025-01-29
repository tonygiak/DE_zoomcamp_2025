#!/bin/bash

echo "Starting workspace backup..."

# Install correct PostgreSQL client if not present
if ! command -v pg_dump &> /dev/null; then
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y postgresql-client-13
fi

# Create backup directory
mkdir -p backups

# Backup database
echo "Creating database backup..."
pg_dump -U root -h localhost ny_taxi > backups/backup.sql

# Git operations
echo "Committing changes to repository..."
git add backups/backup.sql
git commit -m "backup: Update PostgreSQL data backup"
git push origin main

echo "Workspace backup completed!"