# syntax=docker/dockerfile:1.7
# dev   -> servidor do Vite com recarga automática (usado no docker compose)
# build -> gera os arquivos estáticos em /app/dist (deploy, mais adiante)

ARG NODE_IMAGE=node:24.16.0-bookworm-slim

FROM ${NODE_IMAGE} AS dev
WORKDIR /app
RUN chown node:node /app
USER node

# Primeiro só os arquivos de dependência. npm ci instala EXATAMENTE o package-lock.json.
COPY --chown=node:node package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

COPY --chown=node:node . .
EXPOSE 5173
CMD ["npm", "run", "dev"]


FROM dev AS build
RUN npm run build
