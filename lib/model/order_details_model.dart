import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsModel {
  String? OrderID;
  String? DishID;
  double? Price;
  int? Amount;

  OrderDetailsModel({this.DishID, this.OrderID, this.Price, this.Amount});

  factory OrderDetailsModel.fromSnapshotOrder(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return OrderDetailsModel(
      DishID: data['DishID'],
      OrderID: data['OrderID'],
      Amount: data['Amount'] ?? 1,
      Price: data['Price']?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'OrderID': OrderID,
      'DishID': DishID,
      'Price': Price,
      'Amount': Amount,
    };
  }
}
