use('myDatabase');

db.orders.aggregate([
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
  ]).explain("executionStats");