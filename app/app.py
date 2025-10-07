from flask import Flask, jsonify, request
from pymongo import MongoClient
import os

app = Flask(__name__)

MONGO_URI = os.environ.get("MONGO_URI", "mongodb://127.0.0.1:27017")
client = MongoClient(MONGO_URI)
db = client.wizdb
todos = db.todos

@app.route("/")
def index():
    return jsonify({"message":"WizExercise app running"}), 200

@app.route("/todos", methods=["GET","POST"])
def todos_route():
    if request.method == "POST":
        data = request.get_json() or {}
        todos.insert_one(data)
        return jsonify({"status":"ok"}), 201
    else:
        out = []
        for doc in todos.find({}, {"_id":0}):
            out.append(doc)
        return jsonify(out), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
