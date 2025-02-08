#!/bin/bash
set -e  # Exit on errors

DB_USER="postgres"
DB_NAME="mydatabase"
SQL_FILE="/workspace/Capstone/sql/base.sql"

echo "Waiting for PostgreSQL to start..."
until pg_isready -h localhost -U $DB_USER; do
  sleep 1
done

echo "PostgreSQL is ready!"

# Check if the database exists
DB_EXISTS=$(psql -U $DB_USER -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "no" ]; then
  echo "Database does not exist. Creating..."
  psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"
fi

# Check if the public schema has any user-created tables
USER_TABLE_COUNT=$(psql -U $DB_USER -d $DB_NAME -tAc "
SELECT count(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
")

if [ "$USER_TABLE_COUNT" -eq 0 ]; then
  echo "No user tables found in $DB_NAME. Restoring from base.sql..."
  psql -U $DB_USER -d $DB_NAME -f "$SQL_FILE"
else
  echo "Database already has tables. Skipping restore."
fi
