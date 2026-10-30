#!/usr/bin/env bash
# Regera os arquivos travados do backend dentro de um container (reprodutível).
# Uso: ./scripts/lock.sh   (rode da raiz do projeto)
set -euo pipefail
cd "$(dirname "$0")/.."

docker run --rm \
  -u "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e PIP_DISABLE_PIP_VERSION_CHECK=1 \
  -v "$PWD/backend:/w" -w /w \
  python:3.12.16-slim-bookworm \
  sh -c '
    pip install --quiet --user uv==0.13.6 &&
    ~/.local/bin/uv pip compile requirements.in \
      --universal --python-version 3.12 --generate-hashes -o requirements.lock &&
    ~/.local/bin/uv pip compile requirements-dev.in \
      --universal --python-version 3.12 --generate-hashes -o requirements-dev.lock
  '

echo "OK: backend/requirements.lock e backend/requirements-dev.lock gerados."