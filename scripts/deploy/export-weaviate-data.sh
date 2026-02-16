#!/usr/bin/env bash
set -euo pipefail

backup_path="${1:-$PWD/weaviate-data.tar.gz}"
project_name="${COMPOSE_PROJECT_NAME:-$(basename "$PWD")}"
volume_name="${2:-${project_name}_weaviate_data}"

if ! docker volume inspect "$volume_name" >/dev/null 2>&1; then
  echo "Volume not found: $volume_name"
  echo "Check available volumes: docker volume ls | grep weaviate_data"
  exit 1
fi

docker compose down

docker run --rm \
  -v "$volume_name":/data \
  -v "$(dirname "$backup_path")":/backup \
  alpine tar czf "/backup/$(basename "$backup_path")" -C /data .

echo "Exported backup: $backup_path"
