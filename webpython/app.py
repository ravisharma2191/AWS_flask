from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient
from pymongo import MongoClient
import certifi
app = Flask(__name__)

# MongoDB Atlas Connection
client = MongoClient(
    "mongodb+srv://ravisharmabmchrc_db_user:2M3kUaevzKfcJIN7@jaypathon.wkjug8m.mongodb.net/mydatabase?retryWrites=true&w=majority",
    tls=True,
    tlsCAFile=certifi.where()   # IMPORTANT FIX
)

# Select database & collection
db = client["Jaypathon"]
collection = db["mycollection"]


@app.route("/", methods=["GET", "POST"])
def index():
    error = None

    if request.method == "POST":
        name = request.form.get("name")
        email = request.form.get("email")

        try:
            # Insert into MongoDB
            collection.insert_one({"name": name, "email": email})
            return redirect(url_for("success"))

        except Exception as e:
            error = f"Error submitting data: {e}"

    return render_template("form.html", error=error)


@app.route("/success")
def success():
    return render_template("success.html")


if __name__ == "__main__":
    app.run(debug=True)
