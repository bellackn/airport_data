# Coding Challenge – Backend Developer

Inside this repository, you will find a complete Docker setup for

* a PostgreSQL database that holds data about various airports and
* a Flask API that fetches results from this DB.

The airport data were downloaded from [ourairports.com](http://ourairports.com/data/airports.csv).

## System Requirements

* Docker and Docker Compose
* Reasonably recent browser
* For querying and testing, tools like `curl` and `jq` might be handy.

## How to Install

The API and the database are both run inside distinct Docker containers. You can build and start everything using the provided Makefile:

```
make build start
make stop
```
The API will then listen on port 5000 on your local machine.

If you don't have `make` installed on your machine, you can go with `docker-compose build && docker-compose up -d`.

## API Endpoints

The Flask API has two endpoints, one for looking up airports by their IATA code, and one for looking up airports by their name (partial matching allowed).

### `/iata` (GET)

The `/iata` endpoint allows for looking up airports by their IATA code. If the code is found inside the database, a JSON response containing the matching airport will be returned, along with a HTTP 200. If not, a 404 will be returned, plus an error message.

Example:
```
nico@lapap12:~/local$ make build start
[...]
nico@lapap12:~/local$ curl -v localhost:5000/iata/sxf
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 5000 (#0)
> GET /iata/sxf HTTP/1.1
> Host: localhost:5000
> User-Agent: curl/7.58.0
> Accept: */*
> 
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Content-Type: application/json
< Content-Length: 150
< Server: Werkzeug/0.15.2 Python/3.7.2
< Date: Fri, 03 May 2019 11:53:09 GMT
< 
{"name": "Berlin-Schönefeld Airport", "iata": "SXF", "icao": "EDDB", "city": "Berlin", "country": "DE", "latitude": 52.380001, "longitude": 13.5225}
* Closing connection 0
```

For a nicely formatted output in your command line, use `jq`:

```
nico@lapap12:~/local$ curl -s localhost:5000/iata/sxf | jq
{
  "name": "Berlin-Schönefeld Airport",
  "iata": "SXF",
  "icao": "EDDB",
  "city": "Berlin",
  "country": "DE",
  "latitude": 52.380001,
  "longitude": 13.5225
}
```

### `/name` (GET)

The `/name` endpoint allows for looking up airports by their name. If the name is found inside the database (partial matching allowed; case-insensitive), a JSON response containing the matching airport(s) will be returned, along with a HTTP 200. If not, a 404 will be returned, plus an error message.

Example:
```
nico@lapap12:~/local$ curl localhost:5000/name/teGeL[
    {
        "name": "Tegeler Airport",
        "iata": null,
        "icao": "27WI",
        "city": "Prescott",
        "country": "US",
        "latitude": 44.8077011108398,
        "longitude": -92.7137985229492
    },
    {
        "name": "Berlin-Tegel Airport",
        "iata": "TXL",
        "icao": "EDDT",
        "city": "Berlin",
        "country": "DE",
        "latitude": 52.5597,
        "longitude": 13.2877
    }
]
```

## Unit Tests

For now, there are two simple tests living in `./tests/test_endpoints.py`. They can be run via `pytest`. Just run `make test`.
This will build a distinct Docker image for testing the API and spin up a container from it afterwards. This container then runs the tests. If you do not use the Makefile for this, you must make sure that the database and the API containers are up and running.

## Notes

* If you want to use CLI tools like `curl` to test the API, it is worth mentioning that you have to URL-encode possible non-ASCII characters in your request (your browser does that automatically) – e.g. by considering a website [like this](https://www.i18nqa.com/debug/utf8-debug.html). I haven't figured out a way to circumvent this yet... For example, looking for "schöne" at the `/name` endpoint would work like this:
    ```
    nico@lapap12:~/local$ curl localhost:5000/name/sch%C3%B6ne
    [
        {
            "name": "Berlin-Schönefeld Airport",
            "iata": "SXF",
            "icao": "EDDB",
            "city": "Berlin",
            "country": "DE",
            "latitude": 52.380001,
            "longitude": 13.5225
        },
        {
            "name": "Schönebeck-Zackmünde Airport",
            "iata": null,
            "icao": "EDOZ",
            "city": "Schönebeck",
            "country": "DE",
            "latitude": 51.9966659545898,
            "longitude": 11.7908334732056
        }
    ]
    ```
