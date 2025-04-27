from pymongo import MongoClient
import random
from datetime import datetime

client = MongoClient("mongodb://localhost:27017")

db = client["performance_test"]
collection = db["sales"]

def claim():
    collection.create_index([("category", 1)])
    print("Index has been successfully created")