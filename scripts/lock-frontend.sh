#!/usr/bin/env bash
# Gera/atualiza frontend/package-lock.json dentro de um container Node.
# Uso: ./scripts/lock-frontend.sh   (rode da raiz do projeto)
set -euo pipefail
cd "$(dirname "$0")/.."

IMAGEM="node:24.16.0-bookworm-slim"

DOCKER_ARGS=(--rm)
DOCKER_ARGS+=(-u "$(id -u):$(id -g)")
DOCKER_ARGS+=(-e HOME=/tmp)
DOCKER_ARGS+=(-v "$PWD/frontend:/app")
DOCKER_ARGS+=(-w /app)

docker run "${DOCKER_ARGS[@]}" "$IMAGEM" sh -c "npm install --no-audit --no-fund && npm run lint && npm run build"

rm -rf frontend/node_modules frontend/dist
echo "OK: frontend/package-lock.json gerado; lint e build passaram."
