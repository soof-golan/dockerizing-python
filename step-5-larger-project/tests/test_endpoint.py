import pytest
from fastapi.testclient import TestClient
from larger_project.main import app


@pytest.fixture()
def client():
    with TestClient(app) as client:
        yield client


def test_endpoint(client: TestClient):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"variant": "larger_project"}
