from pymongo import MongoClient
import certifi

# MongoDB Atlas Connection
client = MongoClient(
    "mongodb+srv://ravisharmabmchrc_db_user:2M3kUaevzKfcJIN7@jaypathon.wkjug8m.mongodb.net/mydatabase?retryWrites=true&w=majority",
    tls=True,
    tlsCAFile=certifi.where()   # IMPORTANT FIX
)
db = client["Jaypathon"]
todo_collection = db.todo_items