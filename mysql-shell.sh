#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: .env não encontrado em $ENV_FILE. ABORTING."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

MYSQL_CONTAINER="${MYSQL_CONTAINER_NAME:-mysql}"

# Resolve credentials: prefer MYSQL_ADMIN_* when all four are set
if [ -n "$MYSQL_ADMIN_HOST" ] && [ -n "$MYSQL_ADMIN_PORT" ] && \
   [ -n "$MYSQL_ADMIN_USER" ] && [ -n "$MYSQL_ADMIN_PASSWORD" ]; then
  DB_USER="$MYSQL_ADMIN_USER"
  DB_PASS="$MYSQL_ADMIN_PASSWORD"
else
  DB_USER="${MYSQL_ROOT_USER:-root}"
  DB_PASS="${MYSQL_ROOT_PASSWORD:-${MYSQL_PASSWORD}}"
fi

if [ -z "$DB_PASS" ]; then
  echo "ERROR: nenhuma senha MySQL encontrada no .env (MYSQL_ROOT_PASSWORD / MYSQL_PASSWORD). ABORTING."
  exit 1
fi

# Try docker exec into the running container first
if docker ps --format '{{.Names}}' | grep -q "^${MYSQL_CONTAINER}\$"; then
  echo "Conectando ao container '$MYSQL_CONTAINER' como usuário '$DB_USER'..."
  docker exec -it "$MYSQL_CONTAINER" \
    mysql -u "$DB_USER" -p"$DB_PASS"
else
  # Container not running — connect via exposed port using a temporary mysql-client container
  NETWORK="${DOCKER_HOST_NETWORK:-jk-network}"
  EXPOSED_PORT="${MYSQL_EXPOSED_PORT:-33061}"
  echo "Container '$MYSQL_CONTAINER' não está rodando."
  echo "Tentando conexão via porta exposta $EXPOSED_PORT (host: 127.0.0.1)..."
  docker run --rm -it \
    --network host \
    mysql:8.0 \
    mysql -h 127.0.0.1 -P "$EXPOSED_PORT" -u "$DB_USER" -p"$DB_PASS"
fi
