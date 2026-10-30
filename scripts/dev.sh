#!/usr/bin/env bash
# Comandos do dia a dia. Uso: ./scripts/dev.sh <comando>   (rode da raiz do projeto)
set -euo pipefail
cd "$(dirname "$0")/.."

DC=(docker compose)
BE=("${DC[@]}" run --rm backend)
FE=("${DC[@]}" run --rm --no-deps frontend)

uso() {
  cat <<'AJUDA'
Comandos:
  up            sobe tudo (banco, backend, frontend) mostrando os logs
  upd           sobe tudo em segundo plano
  down          para tudo (os dados do banco continuam)
  logs          mostra os logs (Ctrl+C para sair)
  ps            mostra o estado dos serviços
  rebuild       reconstrói as imagens e recria o node_modules (use após mudar dependências)

  test          roda os testes do backend
  lint          roda o linter do backend (ruff check + format --check)
  format        formata o código do backend (ruff format + fix)
  fe-lint       roda o linter do frontend (eslint)
  fe-build      roda o build do frontend (TypeScript + Vite)
  check         roda tudo que a automação do GitHub roda: lint, testes, fe-lint, fe-build

  migrate               aplica as migrações (alembic upgrade head)
  migration "mensagem"  cria uma migração nova (só o líder, uma por vez)
  migration-status      mostra a migração atual e as heads

  shell         abre um terminal dentro do container do backend
  psql          abre o psql no banco
  reset-db      APAGA o banco e recomeça do zero

  lock          regera backend/requirements*.lock (só o líder)
  lock-frontend regera frontend/package-lock.json (só o líder)
AJUDA
}

case "${1:-}" in
  up)       "${DC[@]}" up --build ;;
  upd)      "${DC[@]}" up --build -d ;;
  down)     "${DC[@]}" down ;;
  logs)     "${DC[@]}" logs -f ;;
  ps)       "${DC[@]}" ps ;;
  rebuild)  "${DC[@]}" up --build --renew-anon-volumes -d ;;

  test)     "${BE[@]}" pytest ;;
  lint)     "${BE[@]}" sh -c "ruff check . && ruff format --check ." ;;
  format)   "${BE[@]}" sh -c "ruff check --fix . && ruff format ." ;;
  fe-lint)  "${FE[@]}" npm run lint ;;
  fe-build) "${FE[@]}" npm run build ;;
  check)
    "$0" lint
    "$0" migrate
    "$0" test
    "$0" fe-lint
    "$0" fe-build
    echo "OK: tudo passou." ;;

  migrate)          "${BE[@]}" alembic upgrade head ;;
  migration)
    [ -n "${2:-}" ] || { echo 'Uso: ./scripts/dev.sh migration "descricao"'; exit 1; }
    "${BE[@]}" alembic revision --autogenerate -m "$2" ;;
  migration-status) "${BE[@]}" sh -c "alembic current && alembic heads" ;;

  shell)    "${BE[@]}" bash ;;
  psql)     "${DC[@]}" exec db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' ;;
  reset-db)
    read -r -p "Isto APAGA todos os dados do banco local. Digite 'sim' para continuar: " r
    [ "$r" = "sim" ] && "${DC[@]}" down -v ;;

  lock)          ./scripts/lock.sh ;;
  lock-frontend) ./scripts/lock-frontend.sh ;;

  *) uso ;;
esac
