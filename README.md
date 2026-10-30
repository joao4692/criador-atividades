# Criador de Atividades com IA

Sistema web para professores gerarem atividades (questionários) com IA a partir das ementas dos cursos.

**Stack:** FastAPI (Python 3.12) · PostgreSQL 17 · React + Vite · Docker Compose

## Rodando o projeto

Você só precisa de **Docker Desktop** (ou Docker Engine no Linux) e **Git**. Não instale Python, Node ou Postgres na máquina.

```bash
git clone <url-do-repositorio>
cd criador-
cp .env.example .env
./scripts/instalar-hooks.sh

```

No Linux, ajuste o `APP_UID` no `.env` para o resultado de `id -u`. No Windows, se a recarga automática não funcionar, use `WATCH_POLLING=true`.

```bash
docker compose up --build
```

| O quê                   | Endereço                                  |
| ----------------------- | ----------------------------------------- |
| Frontend                | http://localhost:5173                     |
| API                     | http://localhost:8000                     |
| Documentação da API     | http://localhost:8000/docs                |
| Saúde da API / do banco | http://localhost:8000/health · /health/db |

## Comandos do dia a dia

```bash
./scripts/dev.sh            # lista todos os comandos
./scripts/dev.sh test       # testes do backend
./scripts/dev.sh lint       # linter do backend
./scripts/dev.sh fe-lint    # linter do frontend
./scripts/dev.sh check      # tudo que a automação do GitHub roda
./scripts/dev.sh migrate    # aplica as migrações
```

No Windows, rode os scripts pelo **Git Bash** (vem com o Git).

## Como trabalhamos

1. Pegue um cartão em **Pronto para pegar** no quadro do GitHub Projects, atribua a você e mova para **Em andamento**.
2. `git switch main && git pull`
3. Crie a branch com o ID da tarefa: `feat/auth-3-hash-senha`, `fix/...`, `docs/...`
4. Mexa **só nos arquivos da tarefa** (um módulo por tarefa). Commits pequenos: `feat(auth): adiciona hash de senha`
5. Rode `./scripts/dev.sh check` antes de enviar.
6. Abra o PR contra a `main`, preencha o modelo e cite a Issue (`Closes #12`). Mova o cartão para **Em revisão**.
7. Depois do merge, volte para a `main` e atualize antes de pegar a próxima tarefa.

### Regras

- Ninguém faz push direto na `main`. Tudo entra por PR, com aprovação do líder, testes e linter passando, e **Squash and merge**.
- `app/main.py`, `app/core/`, `docker-compose.yml`, Dockerfiles, dependências e migrações só mudam com o líder.
- **Dependência nova:** abra uma Issue com o modelo "Pedido de dependência". Não instale nem edite `requirements*` ou `package*.json`.
- **Migrações:** uma pessoa por vez, combinado no quadro.
- **Segredos:** nunca no código. A chave do Grok fica só no seu `.env`.

## Dependências recusadas

| Biblioteca | Motivo | Data |
| ---------- | ------ | ---- |
| —          | —      | —    |
