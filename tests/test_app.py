from app.main import app
 
def test_home():
    client = app.test_client()
    assert b"Hello" in client.get("/").data
 
def test_health():
    assert app.test_client().get("/health").data == b"ok"
