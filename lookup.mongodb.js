use('myDatabase');

db.orders.insertMany([
    {
      _id: ObjectId(),
      orderId: "ORD004",
      customerId: ObjectId("680ca618a3ebf9277ecdcdfd"),
      date: ISODate("2024-11-13"),
      items: [
        { product: "Keyboard", quantity: 1, price: 80 },
        { product: "Mouse", quantity: 1, price: 50 }
      ],
      status: "Shipped"
    }
])

let sixth = db.orders.aggregate([
    {
      $lookup: {
        from: "customers",          
        localField: "customerId",    
        foreignField: "_id",         
        as: "customerInfo"        
      }
    },
    {
      $unwind: "$customerInfo"    
    }
  ]).toArray();
  
let seventh = db.orders.aggregate([
    {
      $group: {
        _id: "$customerId",  
        totalOrders: { $sum: 1 } 
      }
    },
    {
      $sort: { totalOrders: -1 } 
    },
    {
      $lookup: {
        from: "customers",
        localField: "_id",
        foreignField: "_id",
        as: "customerInfo"
      }
    },
    {
      $unwind: "$customerInfo"
    },
    {
      $project: {
        _id: 0,
        customerName: "$customerInfo.name",
        email: "$customerInfo.email",
        totalOrders: 1
      }
    }
  ]).toArray();

[sixth, seventh]

var cleanup = db.orders.deleteMany({ orderId: "ORD004" });