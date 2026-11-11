# Criador de Atividades com IA

Sistema web para professores gerarem atividades (questionários) com IA a partir das ementas dos cursos.

**Stack:** FastAPI (Python 3.12) · PostgreSQL 17 · React + Vite · Docker Compose

## Rodando o projeto

Você só precisa de **Docker Desktop** (ou Docker Engine no Linux) e **Git**. Não instale Python, Node ou Postgres na máquina.

```bash
git clone <url-do-repositorio>
cd criador-atividades
cp .env.example .env
```

No Linux, ajuste o `APP_UID` no `.env` para o resultado de `id -u`. No Windows, se a recarga automática não funcionar, use `WATCH_POLLING=true`.

```bash
docker compose up --build
```

| O quê | Endereço |
|---|---|
| Frontend | http://localhost:5173 |
| API | http://localhost:8000 |
| Documentação da API | http://localhost:8000/docs |
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

Primeira tarefa? Leia o guia passo a passo: [Como fazer uma tarefa](docs/como-fazer-uma-tarefa.md).
O plano das sprints e como ajustá-lo: [Planejamento das sprints](docs/planejamento-das-sprints.md).

1. Pegue um cartão em **Pronto Pra Pegar** no quadro do GitHub Projects, atribua a você e mova para **Em Andamento**.
2. `git switch develop && git pull`
3. Crie a branch com o ID da tarefa: `feat/auth-3-hash-senha`, `fix/...`, `docs/...`
4. Mexa **só nos arquivos da tarefa** (um módulo por tarefa). Commits pequenos: `feat(auth): adiciona hash de senha`
5. Rode `./scripts/dev.sh check` antes de enviar.
6. Abra o PR contra a `develop`, preencha o modelo e cite a Issue (`Closes #12`). O cartão vai para **Em Revisão**.
7. Depois do merge, volte para a `develop` e atualize antes de pegar a próxima tarefa.

### Regras

- Ninguém faz push direto na `develop` nem na `main`: o GitHub recusa. Tudo entra por PR, com as três verificações verdes e a revisão do líder.
- A `develop` é a branch do dia a dia. O PR de uma tarefa entra nela com **Squash and merge**.
- A `main` é a versão estável: só recebe código da `develop`, em um PR aberto pelo líder, com **Create a merge commit**.
- `app/main.py`, `app/core/`, `docker-compose.yml`, Dockerfiles, dependências e migrações só mudam com o líder.
- **Dependência nova:** abra uma Issue com o modelo "Pedido de dependência". Não instale nem edite `requirements*` ou `package*.json`.
- **Migrações:** uma pessoa por vez, combinado no quadro.
- **Segredos:** nunca no código. A chave do Grok fica só no seu `.env`.

## Proteções do repositório

O repositório é público. O que o mantém seguro são estas camadas:

| Camada | O que garante |
|---|---|
| `.env` fora do Git | A senha do banco e a chave do Grok nunca entram no repositório. Só o `.env.example`, com valores fictícios, é versionado |
| Varredura de segredos (secret scanning) | O GitHub avisa se uma chave conhecida aparecer no código ou no histórico |
| Bloqueio de envio (push protection) | O GitHub recusa o `git push` que contém uma chave |
| Regra `proteger-develop` | A `develop` só recebe código por PR, com `backend`, `frontend` e `governanca` verdes, em squash |
| Regra `proteger-main` | A `main` só recebe código por PR, com as mesmas verificações, em merge commit. A `governanca` reprova PR que não venha da `develop` |

As duas regras também impedem apagar a branch e reescrever o histórico dela, e valem para todos, inclusive o líder. Elas ficam em **Settings → Rules → Rulesets**.

**Por que squash na `develop` e merge commit na `main`:** o squash junta os commits da tarefa em um só, o que deixa a `develop` com uma linha por tarefa. Na promoção para a `main`, o squash criaria um commit que não existe na `develop`, e as duas branches passariam a divergir. O merge commit leva os commits da `develop` como estão.

**Se uma chave vazar mesmo assim:** troque a chave no serviço de origem na hora (gerar outra e invalidar a antiga). Apagar o commit não resolve, porque a chave já pode ter sido copiada.

## Dependências recusadas

| Biblioteca | Motivo | Data |
|---|---|---|
| — | — | — |
