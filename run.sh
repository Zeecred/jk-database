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

NETWORK="${DOCKER_HOST_NETWORK:-jk-network}"
PYTHON_IMAGE="python:3.12-slim"
CONTAINER_NAME="jk-db-setup"

echo "Rede Docker: $NETWORK"
echo "Usando imagem $PYTHON_IMAGE para rodar os scripts de banco."

docker pull "$PYTHON_IMAGE"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
  echo "Removendo container antigo ${CONTAINER_NAME}..."
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
fi

docker run --rm \
  --name "$CONTAINER_NAME" \
  --network "$NETWORK" \
  -v "$PROJECT_ROOT":/workspace \
  -w /workspace/jk-database \
  -e MYSQL_HOST="mysql" \
  -e MYSQL_EXPOSED_PORT="3306" \
  "$PYTHON_IMAGE" \
  bash -c "apt-get update && apt-get install -y --no-install-recommends pkg-config default-libmysqlclient-dev build-essential && pip install -r requirements.txt && python create_databases.py && python create_users.py"