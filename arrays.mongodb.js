use('myDatabase');

let fourth = db.orders.aggregate([
  {
    $unwind: "$items"
  }
]).toArray(); 


let fifth = db.orders.aggregate([
  {
    $unwind: "$items"
  },
  {
    $group: {
      _id: null,
      totalQuantity: {
        $sum: "$items.quantity"
      }
    }
  }
]).toArray(); 

[fourth, fifth]
