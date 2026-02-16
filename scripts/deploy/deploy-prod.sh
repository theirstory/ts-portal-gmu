#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f config.json ]]; then
  cp config.example.json config.json
  echo "Created config.json from template. Edit it before public launch."
fi

[[ -f .env.production ]] || cp .env.production.example .env.production
[[ -f nlp-processor/.env ]] || cp nlp-processor/.env.example nlp-processor/.env

mkdir -p .yarn

docker compose -f docker-compose.prod.yml up -d --build
docker compose -f docker-compose.prod.yml ps
