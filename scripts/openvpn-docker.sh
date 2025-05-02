#!/usr/bin/env bash

set -e

CONTAINER_NAME="openvpn-as"
DATA_DIR="/home/anokxz/openvpn"

# Check if docker is available
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Please enable it in your /etc/nixos/configuration.nix:"
  echo "  virtualisation.docker.enable = true;"
  echo "Then run: sudo nixos-rebuild switch"
  exit 1
fi

# Check if the container exists
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo "Container '$CONTAINER_NAME' already exists."

  read -rp "Do you want to remove and reinstall it? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Stopping and removing container..."
    docker stop "$CONTAINER_NAME" || true
    docker rm "$CONTAINER_NAME" || true
  else
    echo "Exiting without changes."
    exit 0
  fi
fi

# Create data directory
mkdir -p "$DATA_DIR"

# Run container
docker run -d \
  --name="$CONTAINER_NAME" --device /dev/net/tun \
  --cap-add=MKNOD --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v "$DATA_DIR:/openvpn" \
  --restart=unless-stopped \
  openvpn/openvpn-as

echo "OpenVPN Access Server container started."

# Prompt for password
read -rp "Set admin password for user 'openvpn': " -s password
echo

docker exec -it "$CONTAINER_NAME" sacli --user "openvpn" --new_pass "$password" SetLocalPassword

echo "Admin password set. Access the server at: https://localhost:943/admin"
