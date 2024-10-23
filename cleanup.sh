#!/bin/bash

# Remove Docker container if it exists
remove_container() {
  container_name=$1
  if docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
    docker rm -f "$container_name"
    echo "Removed container: $container_name"
  else
    echo "Container $container_name does not exist."
  fi
}

# Remove Docker network if it exists
remove_network() {
  network_name=$1
  if docker network ls --format '{{.Name}}' | grep -Eq "^${network_name}\$"; then
    docker network rm "$network_name"
    echo "Removed network: $network_name"
  else
    echo "Network $network_name does not exist."
  fi
}

# Remove Docker volume if it exists
remove_volume() {
  volume_name=$1
  if docker volume ls --format '{{.Name}}' | grep -Eq "^${volume_name}\$"; then
    docker volume rm "$volume_name"
    echo "Removed volume: $volume_name"
  else
    echo "Volume $volume_name does not exist."
  fi
}

# Remove containers
remove_container "hyper-postgres"
remove_container "hyper-adminer"

# Remove network
remove_network "hyper-network"

# Remove volume
remove_volume "hyper-volume"