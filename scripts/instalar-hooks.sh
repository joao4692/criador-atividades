#!/usr/bin/env bash
# Liga os hooks do projeto (pasta .githooks). Rode uma vez depois de clonar.
set -euo pipefail
cd "$(dirname "$0")/.."
chmod +x .githooks/*
git config core.hooksPath .githooks
echo "OK: hooks instalados. Push direto na main agora é bloqueado nesta máquina."
