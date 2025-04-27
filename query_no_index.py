from pymongo import MongoClient
import random
from datetime import datetime

client = MongoClient("mongodb://localhost:27017")

db = client["performance_test"]
collection = db["sales"]

def process():
    start_time = datetime.now()
    query = {"category": "Electronics"}
    result = list(collection.find(query))
    end_time = datetime.now()
    execution_time = end_time - start_time
    print(f"Time taken: {execution_time}")