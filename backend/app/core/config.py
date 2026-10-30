"""Configuração central: lê as variáveis do .env."""

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_env: str = "development"
    # Obrigatórias: sem elas no .env, o app não sobe.
    database_url: str
    jwt_secret: str
    jwt_expire_minutes: int = 60
    grok_api_key: str = ""
    grok_model: str = "grok-4"
    cors_origins: str = "http://localhost:5173"

    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
