use('myDatabase');

let firstResult = db.orders.aggregate([ 
  { 
    $match: { 
      date: { 
        $gte: new Date(new Date().setMonth(new Date().getMonth() - 3)) 
      } 
    } 
  }
]).toArray();  

let secondResult = db.orders.aggregate([ 
  {
    $group: {
      _id: { 
        year: { 
          $year: "$date" 
        }, 
        month: { 
          $month: "$date" 
        }
      },
      countOrders: { $sum: 1 }
    }
  }
]).toArray(); 

let thirdResult = db.orders.aggregate([
  {
    $addFields: {
      totalAmount: {
        $sum: {
          $map: {
            input: "$items",
            as: "item",
            in: { $multiply: [ "$$item.price", "$$item.quantity" ] }
          }
        }
      }
    }
  },
  { 
    $sort: { totalAmount: -1 }
  }
]).toArray(); 

[firstResult, secondResult, thirdResult]