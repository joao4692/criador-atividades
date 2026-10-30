# syntax=docker/dockerfile:1.7
# base -> dependências de produção, instaladas SÓ a partir do requirements.lock (com hash)
# dev  -> base + testes e linter, recarga automática (usado no docker compose)
# prod -> base + código, sem ferramentas de desenvolvimento (usado no deploy)

ARG PYTHON_IMAGE=python:3.12.16-slim-bookworm

FROM ${PYTHON_IMAGE} AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Usuário sem privilégio. APP_UID = seu "id -u", para não dar erro de permissão no volume.
ARG APP_UID=1000
RUN groupadd --system --gid ${APP_UID} app \
 && useradd --system --uid ${APP_UID} --gid app --home-dir /app --shell /usr/sbin/nologin app

WORKDIR /app
RUN chown app:app /app

# Primeiro só o lock: o Docker reaproveita esta camada enquanto ele não mudar.
# --require-hashes: cada pacote precisa bater com o hash. --no-deps: nada fora do lock.
COPY requirements.lock ./
RUN pip install --require-hashes --no-deps -r requirements.lock && pip check


FROM base AS dev
COPY requirements-dev.lock ./
RUN pip install --require-hashes --no-deps -r requirements-dev.lock && pip check
COPY --chown=app:app . .
USER app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]


FROM base AS prod
COPY --chown=app:app app ./app
COPY --chown=app:app alembic.ini ./
USER app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2", "--proxy-headers"]
