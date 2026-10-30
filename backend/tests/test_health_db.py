def test_health_db_conecta_no_banco(client):
    resposta = client.get("/health/db")
    assert resposta.status_code == 200
    assert resposta.json()["database"] == "ok"
