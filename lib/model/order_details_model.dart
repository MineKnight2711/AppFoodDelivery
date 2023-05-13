class OrderDetailsModel {
  String? OrderID;
  String? DishID;
  double? Price;
  int? Amount;

  OrderDetailsModel({this.DishID, this.OrderID, this.Price, this.Amount});

  Map<String, dynamic> toMap() {
    return {
      'OrderID': OrderID,
      'DishID': DishID,
      'Price': Price,
      'Amount': Amount,
    };
  }
}
