import json, requests

def test_iata():
    """
    GIVEN the running airport database and API
    WHEN an IATA code is being requested
    THEN check whether the API responds with the correct airports
    """
    r = requests.get("http://api:5000/iata/txl")
    assert "Tegel" in json.dumps(r.json())

def test_name():
    """
    GIVEN the running airport database and API
    WHEN an airport's name is being requested
    THEN check whether the API responds with the correct airports
    """
    r = requests.get("http://api:5000/name/tEgEl")
    assert "Tegel" in json.dumps(r.json())