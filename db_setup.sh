#!/bin/bash

# Retrieve environment variables from the container
postgres_db=$(docker exec hyper-postgres printenv POSTGRES_DB)
postgres_user=$(docker exec hyper-postgres printenv POSTGRES_USER)

# Check if environment variables were retrieved successfully
if [ -z "$postgres_db" ] || [ -z "$postgres_user" ]; then
  echo "Error: Could not retrieve PostgreSQL environment variables."
  exit 1
fi

# SQL commands to create table and insert record
initialize_db="
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    user_first_name VARCHAR(99),
    user_last_name VARCHAR(99)
);

INSERT INTO users (id, user_first_name, user_last_name) VALUES (1, 'Danijel', 'Dragicevic')
ON CONFLICT (id) DO NOTHING;
"
# Execute the SQL commands inside the Postgres container
if docker exec --interactive hyper-postgres psql \
  --username="$postgres_user" \
  --dbname="$postgres_db" \
  --command="$initialize_db"; then
  echo "Table created and record inserted successfully."
else
  echo "Error: Failed to initialize the database."
  exit 1
fi
