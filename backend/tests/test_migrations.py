"""Garante uma única 'head' no Alembic (pega migrações criadas em paralelo)."""

from alembic.config import Config
from alembic.script import ScriptDirectory


def test_alembic_tem_uma_unica_head():
    script = ScriptDirectory.from_config(Config("alembic.ini"))
    heads = script.get_heads()
    assert len(heads) <= 1, f"Mais de uma head de migração: {heads}. Rode: alembic merge heads"
