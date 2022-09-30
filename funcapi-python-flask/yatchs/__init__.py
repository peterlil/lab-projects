import logging
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
import azure.functions as func

app = Flask(__name__)
api = Api(app)

data={ 
    "yatchs": [ 
        {
            "id": 1, 
            "name": "Rambler 88", 
            "length": 27.0, 
            "year": 2014 
        }, 
        { 
            "id": 2,
            "name": "Comanche", 
            "length": 33.0, 
            "year": 2014 
        } 
    ] 
}

class yatchs(Resource):
    def get(self, id=None):
        if not id:
            return data
        else:
            return data["yatchs"][id-1]

api.add_resource(yatchs, '/yatchs', '/yatchs/<int:id>')

# code for Azure Functions
def main(req: func.HttpRequest, context: func.Context) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    return func.WsgiMiddleware(app.wsgi_app).handle(req, context)
