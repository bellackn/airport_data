import os, psycopg2
from time import sleep
from flask import Flask
from flask_restful import Resource, Api

while True:
    try:
        conn = psycopg2.connect(
            "host=db dbname=paxlife user=admin password={}".format(os.environ.get("DB_ADMIN_PASSWORD"))
        )
        break
    except psycopg2.OperationalError:
        sleep(1)
    finally:
        print("DB connection established.")

cur = conn.cursor()
app = Flask(__name__)
api = Api(app)

class IATA(Resource):
    def get(self, iata): 
        cur.execute("SELECT name, iata_code, gps_code, municipality, iso_country, lat, lon FROM airports;")
        airports = cur.fetchall()
        for a in airports:
            if iata.upper() in a:
                return {
                    "name": a[0],
                    "iata": a[1],
                    "icao": a[2],
                    "city": a[3],
                    "country": a[4],
                    "latitude": a[5],
                    "longitude": a[6]
                }, 200
        return "Error: IATA code '{}' not found".format(iata), 404

class Name(Resource):
    def get(self, name):
        return_list = []
        cur.execute("SELECT name, iata_code, gps_code, municipality, iso_country, lat, lon FROM airports;")
        airports = cur.fetchall()
        for a in airports:
            if name.lower() in a[0].lower():
                return_list.append({
                    "name": a[0],
                    "iata": a[1],
                    "icao": a[2],
                    "city": a[3],
                    "country": a[4],
                    "latitude": a[5],
                    "longitude": a[6]
                })
        if return_list:
            return return_list, 200
        else: 
            return "Error: Name '{}' not found".format(name), 404

api.add_resource(IATA, "/iata/<string:iata>")
api.add_resource(Name, "/name/<string:name>")

if __name__ == "__main__":
    app.config["DEBUG"] = bool(os.environ.get("DEBUG"))
    app.config["RESTFUL_JSON"] = {
        "ensure_ascii": False
    }
    app.run(host = "0.0.0.0")

    conn.close()