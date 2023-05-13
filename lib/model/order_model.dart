class OrderModel {
  String? UserID;
  String? VoucherID;
  bool? PaymentStatus;
  String? OrderStatus;
  DateTime? OrderDate;
  double? Total;
  int? Amount;
  String? PaymentMethod;
  String? DeliveryAddress;

  OrderModel({
    this.UserID,
    this.VoucherID,
    this.PaymentStatus = false,
    this.OrderStatus,
    this.OrderDate,
    this.Total,
    this.Amount,
    this.PaymentMethod,
    this.DeliveryAddress,
  });

  // factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return DishModel(
  //     id: snapshot.id,
  //     Name: data['Name'],
  //     Image: data['Image'],
  //     Price: data['Price'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'UserID': UserID,
      'VoucherID': VoucherID,
      'PaymentStatus': PaymentStatus,
      'OrderStatus': OrderStatus,
      'OrderDate': OrderDate,
      'Total': Total,
      'Amount': Amount,
      'PaymentMethod': PaymentMethod,
      'DeliveryAddress': DeliveryAddress,
    };
  }
}
