"""Ponto de entrada da API. Só o líder edita este arquivo."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.core.health import router as health_router

settings = get_settings()

app = FastAPI(title="Criador de Atividades com IA", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health_router)
# Routers dos módulos entram aqui, um por linha, conforme as tarefas forem mescladas.
