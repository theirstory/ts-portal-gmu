#!/usr/bin/env bash
set -euo pipefail

backup_path="${1:-/root/weaviate-data.tar.gz}"
project_name="${COMPOSE_PROJECT_NAME:-$(basename "$PWD")}"
volume_name="${2:-${project_name}_weaviate_data}"

if [[ ! -f "$backup_path" ]]; then
  echo "Backup file not found: $backup_path"
  exit 1
fi

docker compose -f docker-compose.prod.yml down
docker volume create "$volume_name" >/dev/null

docker run --rm \
  -v "$volume_name":/data \
  -v "$(dirname "$backup_path")":/backup \
  alpine sh -c "rm -rf /data/* && tar xzf /backup/$(basename "$backup_path") -C /data"

echo "Restored backup into volume: $volume_name"
