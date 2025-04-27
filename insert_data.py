from pymongo import MongoClient
import random
from datetime import datetime

client = MongoClient("mongodb://localhost:27024")

db = client["performance_test"]
collection = db["sales"]

categories = ["Electronics", "Clothing", "Books", "Home", "Sports"]

documents = [
	{
    	"customer_id": random.randint(1, 1000),  
    	"category": random.choice(categories),  
    	"amount": random.uniform(5, 500),  
    	"timestamp": datetime(2024, random.randint(1, 12), random.randint(1, 28)) 
	}
	for _ in range(100000) 
]

collection.insert_many(documents)