from flask import Flask, request, jsonify, render_template
from datetime import datetime
from db import todo_collection

app = Flask(__name__)

@app.route("/")
def todo_page():
    return render_template("todo.html")

@app.route("/submittodoitem", methods=["POST"])
def submit_todo_item():
    data = request.get_json()

    todo_collection.insert_one({
        "itemName": data["itemName"],
        "itemDescription": data["itemDescription"],
        "createdAt": datetime.utcnow()
    })

    return jsonify({"message": "To-Do item saved successfully"})

if __name__ == "__main__":
    app.run(debug=True)