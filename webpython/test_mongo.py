from pymongo import MongoClient
import certifi

client = MongoClient(
    "mongodb+srv://ravisharmabmchrc_db_user:2M3kUaevzKfcJIN7@jaypathon.wkjug8m.mongodb.net/mydatabase?retryWrites=true&w=majority",
    tls=True,
    tlsCAFile=certifi.where()   # IMPORTANT FIX
)

try:
    print(client.list_database_names())
    print("Connected Successfully")
except Exception as e:
    print("Connection Failed:", e)
