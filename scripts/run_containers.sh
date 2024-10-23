#!/bin/bash

# Load Docker image versions from external file
if [ -f config/docker_images.env ]; then
  source config/docker_images.env
else
  echo "Error: config/docker_images.env file not found!"
  exit 1
fi

# Load database credentials from external file
if [ -f config/db_credentials.env ]; then
  source config/db_credentials.env
else
  echo "Error: config/db_credentials.env file not found!"
  exit 1
fi

# Call the script to create Docker network and volume
if ! ./scripts/docker_resources_setup.sh; then
  exit 1
fi

# Start PostgreSQL container
docker run -d \
  --name hyper-postgres \
  --network hyper-network \
  --env POSTGRES_DB="$DB_NAME" \
  --env POSTGRES_USER="$DB_USER" \
  --env POSTGRES_PASSWORD="$DB_PASSWORD" \
  --publish 5432:5432 \
  --volume hyper-volume:/var/lib/postgresql/data \
  "$POSTGRES_IMAGE"

# Start Adminer container
docker run -d \
  --name hyper-adminer \
  --network hyper-network \
  --publish 8080:8080 \
  "$ADMINER_IMAGE"

# Initial delay to give PostgreSQL some time to start
echo "Waiting for PostgreSQL to initialize..."
sleep 5

# Possible exit codes for pg_isready:
# 0: The server is accepting connections.
# 1: The server is rejecting connections.
# 2: There was no response from the server.
# 3: A connection could not be established.
check_postgres_ready() {
  docker exec hyper-postgres pg_isready --username="$DB_USER" --dbname="$DB_NAME" >/dev/null 2>&1
}

# Loop until PostgreSQL is ready (0 for true, otherwise false)
until check_postgres_ready; do
  echo "Postgres is not ready yet, waiting..."
  sleep 2
done

# Call the script to initialize the database:
if ! ./scripts/db_setup.sh; then
  exit 1
fi

# Check the status of the containers
postgres_status=$(docker inspect -f '{{.State.Status}}' hyper-postgres)
adminer_status=$(docker inspect -f '{{.State.Status}}' hyper-adminer)

# Output container status
if [ "$postgres_status" == "running" ] && [ "$adminer_status" == "running" ]; then
  echo "The Postgres and Adminer containers are up and running:"
else
  echo "The Postgres and/or Adminer containers are not running correctly:"
fi

# List all running containers
docker ps -a \
  --filter "name=hyper-postgres" \
  --filter "name=hyper-adminer" \
  --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"