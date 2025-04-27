use('myDatabase');

db.createCollection("orders")
db.createCollection("products")
db.createCollection("customers")


db.products.insertMany([
     {
       _id: ObjectId(),
       name: "Laptop",
       category: "Electronics",
       price: 1200,
       stock: 15
     },
     {
       _id: ObjectId(),
       name: "Mouse",
       category: "Electronics",
       price: 50,
       stock: 100
     },
     {
       _id: ObjectId(),
       name: "Keyboard",
       category: "Electronics",
       price: 80,
       stock: 50
     },
     {
       _id: ObjectId(),
       name: "Desk Chair",
       category: "Furniture",
       price: 300,
       stock: 20
     }
   ])

db.customers.insertMany([
     {
       _id: ObjectId(),
       name: "John Doe",
       email: "john.doe@example.com",
       city: "New York",
       registeredAt: ISODate("2021-03-15")
     },
     {
       _id: ObjectId(),
       name: "Jane Smith",
       email: "jane.smith@example.com",
       city: "Los Angeles",
       registeredAt: ISODate("2022-07-22")
     },
     {
       _id: ObjectId(),
       name: "Alex Johnson",
       email: "alex.johnson@example.com",
       city: "Chicago",
       registeredAt: ISODate("2023-01-10")
     }
   ])


db.orders.insertMany([
    {
      _id: ObjectId(),
      orderId: "ORD001",
      customerId: ObjectId("680ca618a3ebf9277ecdcdfb"),
      date: ISODate("2025-02-12"),
      items: [
        { product: "Laptop", quantity: 1, price: 1200 },
        { product: "Mouse", quantity: 2, price: 50 }
      ],
      status: "Completed"
    },
    {
      _id: ObjectId(),
      orderId: "ORD002",
      customerId: ObjectId("680ca618a3ebf9277ecdcdfc"),
      date: ISODate("2024-12-31"),
      items: [
        { product: "Desk Chair", quantity: 1, price: 300 }
      ],
      status: "Pending"
    },
    {
      _id: ObjectId(),
      orderId: "ORD003",
      customerId: ObjectId("680ca618a3ebf9277ecdcdfd"),
      date: ISODate("2024-11-13"),
      items: [
        { product: "Keyboard", quantity: 1, price: 80 },
        { product: "Mouse", quantity: 1, price: 50 }
      ],
      status: "Shipped"
    }
  ])
  