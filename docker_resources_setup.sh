#!/bin/bash

# Create Docker network if it doesn't already exist
docker network inspect hyper-network >/dev/null 2>&1 || \
docker network create hyper-network

# Check if the Docker network was created successfully
if ! docker network inspect hyper-network >/dev/null 2>&1; then
  echo "Error: Failed to create Docker network 'hyper-network'."
  exit 1
fi

# Create Docker volume if it doesn't already exist
docker volume inspect hyper-volume >/dev/null 2>&1 || \
docker volume create hyper-volume

# Check if the Docker volume was created successfully
if ! docker volume inspect hyper-volume >/dev/null 2>&1; then
  echo "Error: Failed to create Docker volume 'hyper-volume'."
  exit 1
fi

echo "Docker network and volume created successfully."