#!/bin/bash
set -e  # Exit on errors

DB_USER="postgres"
DB_NAME="postgres"
SQL_FILE="/workspace/Capstone/sql/base.sql"

echo "Waiting for PostgreSQL to start..."
until pg_isready -h localhost -U $DB_USER; do
  sleep 1
done

echo "PostgreSQL is ready!"

# Create database if it doesn't exist
psql -U $DB_USER -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 || psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"

# Run SQL script
if [ -f "$SQL_FILE" ]; then
  echo "Executing base.sql..."
  psql -U $DB_USER -d $DB_NAME -f "$SQL_FILE"
else
  echo "base.sql not found. Skipping."
fi
